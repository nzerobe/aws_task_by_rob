server '3.217.117.234', user: 'app', roles: %w{app db web}
set :ssh_options, keys:'/home/app/.ssh/id_rsa'