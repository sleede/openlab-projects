module Search
  module Project
    def self.full_text(q)
      query = {
        query: {
          multi_match: {
            query: q,
            type: "most_fields",
            fields: [
              "name.std^5", "name.fr^5", "name.fr_no_accent^5",
              "description.std^3", "description.fr^3", "description.fr_no_accent^3",
              "tag.std^3", "tag.fr^3", "tag.fr_no_accent^3",
              "machine^2",
              "components.std", "components.fr", "components.fr_no_accent",
              "themes.std", "themes.fr", "themes.fr_no_accent",
              "author.std^2", "author.std_no_accent^2",
              "collaborators.std^2", "collaborators.std_no_accent^2",
              "steps_body.std", "steps_body.fr", "steps_body.fr_no_accent",
            ]
          }
        }
      }

      ::Project.search(query)
    end
  end
end
