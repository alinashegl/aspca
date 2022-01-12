//Purpose:
//This app action will create resources and folders based on Salesforce object and Fields
//define the target object, the field for the resource name, and the field for the folder name

//Action Type: App Action - On Resources Fetched
//Prevent Default Action: Yes

//More info on custom actions here:
//https://docs.dayback.com/article/140-custom-app-actions

//create new array to overwrite resources
var resources = [];
seedcodeCalendar.init('resources', resources);

//retrieve our canvas client object for authentication
var client = fbk.client();

//retrieve our canvas context object for REST links/urls
//determine if we display the default dayback, or object specific
var context = fbk.context();
var sfObject = 'default';
if (context.environment.record.attributes != undefined) {
  sfObject = context.environment.record.attributes.type;
}

//retrieve the query URL from context
var url = '/services/apexrest/resources?sfObject=' + sfObject;

//build settings object for Ajax call to Salesforce
var settings = {};
settings.client = client;
settings.contentType = 'application/json';
settings.success = processResult;

//Use canvas function to query
Sfdc.canvas.client.ajax(url, settings);

var folderIndex = {};
var resource;

//callback for ajax call
function processResult(data) {
  if (data.status == 200) {
    var resp = data.payload;
    //build array pf folder names
    var folders = resp.folders;
    var folderInfos = resp.folderInfos;
    var folder;

    // create folders
    for (var i = 0; i < folders.length; i++) {
      folder = createFolder(folderInfos[i]);
      folderIndex[folder.folderName] = folder;
      resources.push(folder);
    }

    createResources(resp.resources);

    //insert the generic resources
    for(var i = 0; i < resp.genResources.length; i++){
      var tempResource = resp.genResources[i];
      var resource = {
          id: tempResource.id,
          name: tempResource.name,
          nameSafe: tempResource.nameSafe,
          shortName: tempResource.shortName,
          status: {
            selected: sfObject == tempResource.statusSelected,
          },
        };
    
        resources.unshift(resource);
    }

    //continue actions
    action.callbacks.confirm();

    // Update resource selection after resources have been populated
    // only if customResources param not set to true
    if (location.hash.indexOf('customResources=true') < 0) {
      setTimeout(function () {
        resources.forEach(function (resource) {
          if (resource.folderName && folderIndex[resource.folderName]) {
            resource.status.selected =
              folderIndex[resource.folderName].status.selected;
          }
        });
        dbk.resetResources();
        location.hash += '&sidebarShow=true';
      }, 100);
    }
  }
}

function createResources(data) {
  for (var r = 0; r < data.length; r++) {
    var record = data[r];
    resource = createResource(
      record.resourceName,
      folderIndex[record.folderName]
    );
    resources.push(resource);
  }
}

function getObjectInfo(record) {
  var attr = 'attributes';
  return objectInfos[record[attr].type];
}

function createResource(name, folder) {
  var newResource = {};
  newResource.name = name;
  newResource.folderID = folder.folderID;
  newResource.folderName = folder.folderName;
  newResource.id = utilities.generateUID();
  newResource.nameSafe = name;
  newResource.shortName = name;
  newResource.status = {
    folderExpanded: false,
    selected: folder.status.selected,
  };
  return newResource;
}

//creates folder and it's required attributes in the object
function createFolder(folderInfo) {
  var folder = {};
  folder.folderID = utilities.generateUID();
  folder.name = folderInfo.name;
  folder.folderName = folderInfo.name;
  folder.id = folder.folderID;
  folder.nameSafe = folderInfo.name;
  folder.isFolder = true;
  folder.status = {
    folderExpanded: false,
    selected: folderInfo.selected,
  };
  return folder;
}
