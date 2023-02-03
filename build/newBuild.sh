#to run: bash ./build/newBuild.sh

#insert protocols
echo "******** Importing Data **********"
sfdx force:data:tree:import --plan ./build/data/data-load-plan.json --loglevel info > ./build/data/logs/push-data.log

echo "******* Creating bundle entries ******"
sfdx force:apex:execute -f ./build/apex/createTreatmentBundleEntries.apex --loglevel info > ./build/data/logs/execute-apex.log