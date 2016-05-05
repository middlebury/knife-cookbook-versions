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
    end

    banner "knife node cookbook versions NODE"

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
      for cookbook, version in node['cookbook_versions']
        frozen = `knife cookbook show #{cookbook} #{version} | grep frozen`
        puts sprintf('%-30.30s %-20.20s %s', cookbook, version, frozen)
      end
    end
  end
end
