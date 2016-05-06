# knife-node-cookbook-versions
A Chef knife plugin that provides a report of which recipe-versions were deployed to a node and what their status is.

# Installation

Put the `node_cookbook_versions.rb` file in one of the following two places as described in the [Knife Custom Plugins docs](https://docs.chef.io/plugin_knife_custom.html).

* The home directory: `~/.chef/plugins/knife/`
* A `.chef/plugins/knife/` directory in the cookbook repository

As well, the [`cookbook_versions`](https://supermarket.chef.io/cookbooks/cookbook_versions) recipe needs to be added to each node to send the
the cookbook version information back to the chef-server on every `chef-client` run.

# Usage

Call the `knife node cookbook versions NODE` command to print out a report of all cookbooks on a node, what version is installed,
whether or not that version is frozen, and what the environment constraints for that node's environment are for that cookbook.

    $ knife node cookbook versions NODENAME
    node            environment     cookbook             version    frozen?    env. constraint     
    ---------------------------------------------------------------------------------------------
    NODENAME        production      yum                  3.8.2      false      no constraint       
    NODENAME        production      rhsm                 1.0.0      false      no constraint       
    NODENAME        production      web_php_config       1.0.0      true       <= 1.0.0            
    NODENAME        production      web_apache_config    1.0.0      true       <= 1.0.0            
    NODENAME        production      cookbook_versions    0.2.0      true       no constraint           
