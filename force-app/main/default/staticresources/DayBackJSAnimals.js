//local javascript DayBack VF Page.

//You can copy this page and add your own subscription
//events that can be published from DayBack

var DayBack = (function() {
	"use strict";

	var config;
	//Get the initial window height so this works correctly on mobiile.
	var initialWindowHeight = window.innerHeight;

	//Public methods
	return {
		init: init,
		subscribe: subscribe,
		resize: resize,
		publishURL: publishURL,
	};

	//publish our URL parameters to DayBack
	function publishURL() {
		Sfdc.canvas.controller.publish(
			{
				name : 'dbk.url',
        payload : {
				 "url":location.search + 
				 '&sidebarShow=false' + 
				 '&filterResources=' + filterResources + 
				 '&view=basicResourceHor' + 
				 '&source=Beh Med Check Tasks' + 
				 '&source=Beh Treatment Tasks' +
				 '&source=Foster Follow Up Tasks' + 
				 '&source=Playgroup Tasks' + 
				 '&source=Board And Train' + 
				 '&source=Procedures (Read Only)' + 
				 '&source=Vaccines (Read Only)' + 
                 '&customResources=true',
				 "location":window.location.pathname,
			  }
		  }
	  );
	}

	//Subscriptions can be called as custom actions
	//from within the dayback canvas app
	//please don't change the stock events:
	//dbk.navigate
	//dbk.resize
	//dbk.retrieveURL
	//but rather add your own events as needed
	//Use the fbk.publish(<eventname>,<payload>) to call these events
	function subscribe() {
		Sfdc.canvas.controller.subscribe(
			[
				//Standard Dayback Navigation event.
				// '/' + salesforce record id will navigate to that record.
				//payload 'new' property for new window or not.
				{
					"name": "dbk.navigate",
					"onData": function(e) {
						var newTab = e.new;
						var url = e.url;
						var id = e.id;
						var view = e.view;
						if( ( isLightningDesktop() || isMobileOne() ) && id ){
							if(view){
								sforce.one.navigateToSObject(id,view);
							}
							else {
								sforce.one.navigateToSObject(id);
							}
						}
            else if (newTab && url) {
							window.open(url);
						}
						else if(url) {
							window.location.assign(url);
						}
					}
				},
				//this allows us to publish a resize event from within dayback
				{
					"name": "dbk.resize",
					"onData": function(e) {
						resize(e);
					}
				},
				//we call this from dayback after the subscription is activated.
        {
					"name":"dbk.retriveURL",
					"onData": function(e) {
						publishURL();
					}
				},

				//#############################################################
				//#############################################################
				//#############################################################
				//add your event subscription events here separated by commas
				//Use a unique name with the dbk prefix
				//follow the syntax from the above events

	    //#############################################################
			] //end array of subscriptions
		);
	}

	//You shouldn't need to edit below this line


	function init(initialConfig) {
		//Assign config to global var
		config = initialConfig;

		//Resize our view so the iframes are sized correctly
		resize();

		//Add resize event listener
		window.addEventListener("resize", function() {
			resize();
		});
	}

	//function for resizing canvas in vf page.
	//Called after load and resize from vf page.

	function resize(e) {
		var height, target;

		//If we are on mobile web we don't want to run
		//resize as there is a salesforce bug currently
		if (isMobileWeb()) {
			//Mobile web site
			height = getMobileHeight();
		}
		else if (isMobileOne()) {
			//Mobile app
			height = getMobileHeight();
		}
		else if (isLightningDesktop()) {
			//Lightning Desktop
			height = window.innerHeight;
		}
		else {
			//Desktop
			height = getHeight();
		}

		target = {
			"canvas": "dbk"
		};

		Sfdc.canvas.controller.resize({
			"height": height + "px"
		}, target);

		//Returns the height we would like to set the iframe height to
		function getHeight() {
			var headerElement, footerElement, bodyElement, bodyOffset, height;
			try {
				headerElement = document.querySelector(".bPageHeader");
				footerElement = document.querySelector(".bPageFooter");
				bodyElement = document.querySelector(".bodyDiv");
				bodyOffset = bodyElement.offsetHeight - bodyElement.clientHeight;

				height = window.innerHeight - headerElement.offsetHeight - footerElement.offsetHeight - bodyOffset;
			}
			catch(error) {
				height = window.innerHeight - 132;
			}
			return height;
		}

		//Returns the height we would like to set the iframe height to on mobile devices
		function getMobileHeight() {
			var height = initialWindowHeight;
			return height;
		}
	}

	//Functions to determine what platform we are running on
	function isClassicDesktop() {
		var theme = config.theme;
		return theme === 'Theme1' || theme === 'Theme2' || theme === 'Theme3';
	}

	function isLightningDesktop() {
		var theme = config.theme;
		return theme === 'Theme4d';
	}

	function isMobileOne() {
		var theme = config.theme;
		return theme === 'Theme4t';
	}

	//Check if we are on the mobile lightning sites
	function isMobileWeb() {
		var url = window.location.href;
		var matchString = "Host=web";
		return url.indexOf(matchString) > -1;
	}

}());