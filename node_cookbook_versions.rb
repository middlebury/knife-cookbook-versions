# Answer the cookbook versions and their freeze-status for all cookbooks on a node.
# Note: This plugin expects the `cookbook_versions` recipe https://supermarket.chef.io/cookbooks/cookbook_versions
# to have run and populated a node['cookbook_versions'] attribute.
#
# Author: Adam Franco <afranco@middlebury.edu>
# Copyright: 2016 President and Fellows of Middlebury College
# License: GPL V2 or later

require 'chef/knife'

module NodeCookbookVersions
  class NodeCookbookVersions < Chef::Knife

    deps do
      require 'chef/node'
      require "chef/environment"
    end

    banner "knife node cookbook versions NODE"

    option :show_column_header,
      :short => "-n",
      :long => "--no-header",
      :description => "Don't show a column header",
      :boolean => true | false,
      :default => true

    def run
      @node_name = @name_args.first
      if @node_name.nil?
        ui.error "You must specify a node name"
        exit 1
      end

      node = Chef::Node.load(@node_name)

      if node['cookbook_versions'].nil?
        ui.error "#{@node_name} doesn't have any cookbook_versions defined. Be sure to add the 'cookbook_versions' cookbook and run chef-client to populate this attribute."
        exit 2
      end

      env_data = Chef::Environment.load(node.chef_environment)
      columns = '%-15.15s %-15.15s %-25.25s %-10.10s %-10.10s %-20.20s'

      if config[:show_column_header]
        puts sprintf(columns, 'node', 'environment', 'cookbook', 'version', 'frozen?', 'env. constraint')
        puts '-------------------------------------------------------------------------------------------------'
      end

      for cookbook, version in node['cookbook_versions'].sort
        frozen = `knife cookbook show #{cookbook} #{version} | grep frozen | awk '{print $2}'`.strip()
        constraint = env_data.cookbook_versions[cookbook]
        if constraint.nil?
          constraint = "no constraint"
        end
        puts sprintf(columns, @node_name, node.chef_environment, cookbook, version, frozen, constraint)
      end
    end
  end
end
