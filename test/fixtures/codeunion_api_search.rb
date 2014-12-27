module Fixtures
  module CodeUnionAPI
    def self.search_results
      { "REST API" =>
        [{
          "name"        => "linkedout-example",
          "description" => "Example code for codeunion/linkedout: a one-page resume management system.",
          "private"     => true,
          "url"         => "https://github.com/codeunion/linkedout-example",
          "category"    => "examples",
          "tags"        => ["ruby", "sinatra", "javascript", "jquery", "ajax", "request-routing", "json", "dom-manipulation"],
          "access"      => ["students", "staff"],
          "license"     => true,
          "has_wiki"    => false,
          "notes"       => "",
          "excerpt"     => "<match>api</match>-post]:http://api.jquery.com/jquery.post/\n[jquery-<match>api</match>-append]:http://api.jquery.com/append/\n[jquery-<match>api</match>-serialize]:http://api.jquery.com"
        }, {
          "name"        => "overheard-server",
          "description" => "Example project for a web app that stores and shares hilarious, out of context quotess and quips.",
          "private"     =>  false,
          "url"         => "https://github.com/codeunion/overheard-server",
          "category"    => "examples",
          "tags"        => ["ruby", "sinatra", "datamapper", "sqlite"],
          "access"      => ["public", "students", "staff"],
          "license"     => true,
          "has_wiki"    => false,
          "notes"       => "Unclear purpose. Is it an example project or a tool?",
          "excerpt"     => "<match>REST</match> <match>API</match> to add and list Overheards\n\nFor a list of planned and implemented features"
        }]
      }
    end
  end
end
