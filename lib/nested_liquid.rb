require 'active_support/core_ext/module/attribute_accessors'

# nodoc
module Liquid
  mattr_accessor :allowed_namespaces
  Liquid.allowed_namespaces = []

  # nodoc
  class Context

    alias_method :liquid_variable, :variable

    # Recursively renders the liquid calls with the same context until all liquid tags have been rendered
    def render_nested_liquid(liquid_template, context)
      parsed_template = Liquid::Template.parse(liquid_template)
      output = parsed_template.render(context)
      # output.scan(/^#{VariableStart}(.*)#{VariableEnd}$/) do |o|
        # return render_nested_liquid(o, context)
      # end
      output
    end

    # Determine if we're able to call the method. If not we pass the call back to Liquid's standard method
    # 
    # This is dependant on the Liquid.allowed_namespaces being set
    def variable(markup)
      parts = markup.scan(VariableParser)
      first_part = parts.shift

      if Liquid.allowed_namespaces.to_a.include? parts[0]
        #Liquid 2.2 uses environments
        if @environments
          @environments.each do |environment|
            return render_nested_liquid(environment[first_part].send(parts[0]).send(parts[1]), self) if environment.has_key? first_part
          end
        else
          # Liquid < 2.2 uses scopes
          @scopes.each do |scope|
            return render_nested_liquid(scope[first_part].send(parts[0]).send(parts[1]), self) if scope.has_key? first_part
          end
        end
      else
        # If the namespace isn't allowed send the call back to the default Liquid::Context#variable we aliased as liquid_variable above
        liquid_variable(markup)
      end

    end
  end
end

