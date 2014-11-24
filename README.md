MS IIS Server
===============

![](https://s3.amazonaws.com/qubell-images/IIS8.jpg)

Installs and configures MS IIS8 Server

[![Install](https://raw.github.com/qubell-bazaar/component-skeleton/master/img/install.png)](https://express.qubell.com/applications/upload?metadataUrl=https://raw.github.com/qubell-bazaar/component-iis/1.0-35p/meta.yml)
------------------------------------------------

Features
--------
 - Install and configure MS IIS8 Server
 - Manage Application Pools
 - Manage Sites
 - Manage Applications

Configurations
--------------
 - MS IIS8 Server 2008R2, MS Windows 2012-R2 Server (us-east-1/ami-ba13abd2), AWS EC2 m3.medium, Administrator

Pre-requisites
--------------
 - Configured Cloud Account a in chosen environment
 - Either installed Chef on target compute OR launch under Administrator
 - Either installed Cygwin on target compute OR launch under Administrator
 - Internet access from target compute:
   - Microsoft SQL server distribution and additions
   - S3 bucket with Chef recipes: qubell-starter-kit-artifacts

Implementation notes
--------------------
 - Installation is based on Chef recipes from https://github.com/qubell-bazaar/cookbook_qubell_iis

Configuration parameters
------------------------
 - input.server-os: List of available Amazon AMI ID and user identity
 - input.server-os-password: Administrator's password
 - input.server-instance-size:  Amazon instance type
 - input.instance-prefix: Custom Prefix for AWS console Name tag
 - input.recipe-url: URL to chef cookbooks tarball
 - input.iis-modules: List of additional IIS modules to install

Configuration parameters
------------------------
 - `input.server-os:` List of available Amazon AMI ID and user identity
 - `input.server-os-password:` Administrator's password
 - `input.server-instance-size:`  Amazon instance type
 - `input.instance-prefix:` Custom Prefix for AWS console Name tag
 - `input.recipe-url:` URL to chef cookbooks tarball
 - `input.iis-modules:` List of additional IIS modules to install

Action parameters:
------------------
### Manage Application Pools:
 - `pool-name:` Desired Application Pool name (string).
 - `pool-properties:` Additional Pool properties (object).

    Available properties:
     - `pool_name` - name attribute. Specifies the name of the pool to create.
     - `runtime_version` - specifies what .NET version of the runtime to use.
     - `pipeline_mode` - specifies what pipeline mode to create the pool with
     - `private_mem` - specifies the amount of private memory (in kilobytes) after which you want the pool to recycle
     - `worker_idle_timeout` - specifies the idle time-out value for a pool, d.hh:mm:ss, d optional
     - `recycle_after_time` - specifies a pool to recycle at regular time intervals, d.hh:mm:ss, d optional
     - `recycle_at_time` - schedule a pool to recycle at a specific time, d.hh:mm:ss, d optional
     - `max_proc` - specifies the number of worker processes associated with the pool.
     - `thirty_two_bit` - set the pool to run in 32 bit mode, true or false
     - `no_managed_code` - allow Unmanaged Code in setting up IIS app pools
     - `pool_username` - username for the identity for the application pool
     - `pool_password` password for the identity for the application pool
 
    Minimum required example: 
    "{"action":"add"}"

### Manage Site:
 - `site-name:` Desired site name (string).
 - `site-properties:` Additional Site properties (object).

    Available properties:
    - `product_id` - name attribute. Specifies the ID of a product to install.
    - `site_name` - name attribute.
    - `site_id` - if not given IIS generates a unique ID for the site
    - `path` - IIS will create a root application and a root virtual directory mapped to this specified local path
    - `protocol` - http protocol type the site should respond to. valid values are :http, :https. default is :http
    - `port` - port site will listen on. default is 80
    - `host_header` - host header (also known as domains or host names) the site should map to. default is all host headers
    - `options` - additional options to configure the site
    - `bindings` - Advanced options to configure the information required for requests to communicate with a Web site. See http://www.iis.net/configreference/system.applicationhost/sites/site/bindings/binding for parameter format. When binding is used, port protocol and host_header should not be used.
    - `application_pool` - set the application pool of the site
    - `options` - support for additional options -logDir, -limits, -ftpServer, etc...

    
    Minimum required example: 
    "{"action":["add","start"],"application_pool":"test-pool", "bindings":"http://*:80"}"

### Manage Application:
 - `app-name:` Desired Application name (string).
 - `site-name:` Site where you want create application (string).
 - `app-properties:` Additional application properties.
    
    Available properties:
    - `app_name` - name attribute. The name of the site to add this app to
    - `path` -The virtual path for this application
    - `application_pool` - The pool this application belongs to
    - `physical_path` - The physical path where this app resides.
    - `enabled_protocols` - The enabled protocols that this app provides (http, https, net.pipe, net.tcp, etc)

    Minimum required example: 
    "{"action":"add","application_pool":"test-pool"}
