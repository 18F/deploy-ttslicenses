# ttslicenses
Build scripts and templates for ttslicenses. The ttslicenses application uses https://snipeitapp.com/download.

# Templates
The People.csv is used for importing users. At this point, we are only using the first three fields. First Name, Last Name, and User Name. User Name is first.last. 

# Scripts
The build.sh script contains all of the commands to deploy a new docker instance. All of the database connection information has been removed and wil need to be popluated before it is run. 

The manifest.yml is required by CloudFoundry for a successful deployment. 

# Post Deployment

Following deployment, the following commands need to be run: 

- php artisan config:clear
- php artisan migrate
- php artisan view:clear
