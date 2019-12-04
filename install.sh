#!/bin/bash

# Initialize basic vars and helpers
source blueprint-lib/init.sh

##
# Add dependencies here
##

# source blueprint-lib/docker.sh

##
# ADD BLUEPRINT CODE BELOW HERE
#
# BASE_PATH is the full path to the project root
# APP_NAME is the name of the Django app that will be modified
##

BLUEPRINT="Dashboard1Blueprint"
NAME="Dashboard 1"

EXT_POINT_1="@BlueprintInsertion"
EXT_POINT_2="@BlueprintImportInsertion"
EXT_POINT_3="@BlueprintNavigationInsertion"
DATA_1="{ name: '${BLUEPRINT}', human_name: '${NAME}', access_route: '${BLUEPRINT}'},"
DATA_2="import { ${BLUEPRINT}Navigator } from '..\/features\/${BLUEPRINT}\/navigator';"
DATA_3="${BLUEPRINT}: { screen: ${BLUEPRINT}Navigator },"

echo "create blueprint folder"
mkdir -p $BASE_PATH/src/features/$BLUEPRINT

echo "copy"
cp -r ./$BLUEPRINT/. $BASE_PATH/src/features/$BLUEPRINT

echo ">> insert 1" 
sed -i "s/${EXT_POINT_1}/&\n${DATA_1}/g" $BASE_PATH/src/config/installed_blueprints.js

echo ">> insert 2"
sed -i "s/${EXT_POINT_2}/&\n${DATA_2}/g" $BASE_PATH/src/navigator/mainNavigator.js

echo ">> insert 3"
sed -i "s/${EXT_POINT_3}/&\n${DATA_3}/g" $BASE_PATH/src/navigator/mainNavigator.js

BE_BLUEPRINT="dashboard"
NAME="Dashboard 1"
DATA_4="path('api/v1/', include('${dashboard}.api.v1.urls')),"

echo "copy BE for Blueprint"
cp -r ./backend/$BE_BLUEPRINT/. $BASE_PATH/backend/$BE_BLUEPRINT

if ! grep -q $BE_BLUEPRINT $PYTHON_URLS_PATH
then
echo "Adding $BE_BLUEPRINT to urlpatterns"
sed -i '' -e 's/\(urlpatterns =.*\)/\1\'$'\n    '"$DATA_4/" $PYTHON_URLS_PATH
fi

if ! grep -q $BE_BLUEPRINT $PYTHON_SETTINGS_PATH
then
echo "Adding $BE_BLUEPRINT to INSTALLED_APPS"
sed -i '' -e 's/\(INSTALLED_APPS =.*\)/\1\'$'\n    '"'$BE_BLUEPRINT',/" $PYTHON_SETTINGS_PATH
fi
