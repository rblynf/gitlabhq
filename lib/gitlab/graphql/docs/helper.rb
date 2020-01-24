# frozen_string_literal: true

return if Rails.env.production?

module Gitlab
  module Graphql
    module Docs
      # Helper with functions to be used by HAML templates
      # This includes graphql-docs gem helpers class.
      # You can check the included module on: https://github.com/gjtorikian/graphql-docs/blob/v1.6.0/lib/graphql-docs/helpers.rb
      module Helper
        include GraphQLDocs::Helpers

        def auto_generated_comment
          <<-MD.strip_heredoc
            <!---
              This documentation is auto generated by a script.

              Please do not edit this file directly, check compile_docs task on lib/tasks/gitlab/graphql.rake.
            --->
          MD
        end

        def sorted_fields(fields)
          fields.sort_by { |field| field[:name] }
        end

        # Some fields types are arrays of other types and are displayed
        # on docs wrapped in square brackets, for example: [String!].
        # This makes GitLab docs renderer thinks they are links so here
        # we change them to be rendered as: String! => Array.
        def render_field_type(type)
          array_type = type[/\[(.+)\]/, 1]

          if array_type
            "#{array_type} => Array"
          else
            type
          end
        end

        # We are ignoring connections and built in types for now,
        # they should be added when queries are generated.
        def objects
          graphql_object_types.select do |object_type|
            !object_type[:name]["Connection"] &&
              !object_type[:name]["Edge"] &&
              !object_type[:name]["__"]
          end
        end
      end
    end
  end
end
