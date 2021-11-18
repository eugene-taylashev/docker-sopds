#!/bin/sh
#==============================================================================
# Entry point script for a SimpleOPDS image to start the server
#==============================================================================

#=============================================================================
#
#  Variable declarations
#
#=============================================================================
SVER="20211117"     #-- When updated
#VERBOSE=1          #-- 1 - be verbose flag
#DJANGO_SUPERUSER_USERNAME
#DJANGO_SUPERUSER_EMAIL
#DJANGO_SUPERUSER_PASSWORD
DIR_SCAN=/books
DIR_WORK=/sopds

FCFG=${DIR_SCAN}/settings.py  #-- the configuration file may be in the book dir

source /functions.sh #-- Use common functions

#=============================================================================
#
#  MAIN()
#
#=============================================================================
dlog '============================================================================='
dlog "[ok] - starting entrypoint.sh ver $SVER"

get_container_details

#-- Copy the configuration file if in the book directory
if [ -s $FCFG ] ; then
  cp $FCFG $DIR_WORK/sopds/
fi

#-- initialize the database and fill in the initial data (genres)
python3 $DIR_WORK/manage.py migrate
is_good "[ok] - initialized the database" \
"[not ok] - initializing the database"

python3 $DIR_WORK/manage.py sopds_util clear
is_good "[ok] - set the initial data" \
"[not ok] - setting the initial data"

#-- Creating the Superuser
#-- See: https://stackoverflow.com/questions/6244382/how-to-automate-createsuperuser-on-django
echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('$DJANGO_SUPERUSER_USERNAME', '$DJANGO_SUPERUSER_EMAIL', '$DJANGO_SUPERUSER_PASSWORD')"\
 | python3 $DIR_WORK/manage.py shell
is_good "[ok] - created the superuser '$DJANGO_SUPERUSER_USERNAME'" \
"[not ok] - creating the superuser '$DJANGO_SUPERUSER_USERNAME'"

#-- Set the path to the directory with books
python3 $DIR_WORK/manage.py sopds_util setconf SOPDS_ROOT_LIB "$DIR_SCAN"

#-- Starting the built-in HTTP / OPDS server
dlog "[ok] - strating the HTTP / OPDS server: "
python3 $DIR_WORK/manage.py sopds_server start
derr "[not ok] - end of entrypoint.sh"

