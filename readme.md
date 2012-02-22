# Backbone.js Employee Directory #

"Backbone Directory" is a sample application built using [Backbone.js](http://documentcloud.github.com/backbone/) and
 [Twitter Bootstrap](http://twitter.github.com/bootstrap/). The application is an Employee Directory that allows you to
 look for employees by name, view the details of an employee, and navigate up and down the Org Chart by clicking the
 employee’s manager or any of his/her direct reports.

## Set Up: ##

1. Create a MySQL database name "directory".
2. Execute directory.sql to create and populate the "employee" table:

	mysql directory -uroot < directory.sql

## Services: ##

The application is available with a PHP or Java services:

- The PHP services are available in the api directory of this repository. The RESTful services are implemented in PHP using the [Slim framework](http://www.slimframework.com/) (also included in the api directory).
- The Java back-end will be available soon.
- The Perl back-end is in api-perl directory, which is using [Mojolicious](http://mojolicio.us) Web framework, to run perl backend you need to install Mojo framework first as following:
   
. On Unix/Linux just run :
	
> sudo sh -c "curl -L cpanmin.us | perl - Mojolicious"

   On Windows if you have Perl just open command line and enter:

> cpan Mojolicious

. Install DBIx::Simple module using cpan or cpanm

> cpan DBIx::Simple

. Cd to project directory
. Run 

> morbo -v api-perl/backbone-directory.pl	

. Open http://localhost:3000 in browser
