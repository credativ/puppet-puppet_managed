module Puppet::Parser::Functions
  newfunction(:puppet_managed, :type => :rvalue) do |args|
    comment_methods = {
      'hash'    => { :prefix => '#' },
      'c-block' => {
        :block_start => '/*',
        :block_end => '  */',
        :block_continuation => '  *'
      },
    }
    options    = {
      'comment_style'   => 'hash',
      'add_module_name' => false,
    }
    managed_text    = ['MANAGED BY PUPPET']

    if options['add_module_name']
      managed_text.push("Module: #{scope.to_hash['module_name']}")
    end

    unless args.empty?
      user_provided_options = args.shift
      options.merge!(user_provided_options)
    end
    #opts = default_opts

    #opts = {}


    comment_style = options['comment_style']
    unless comment_methods.include?(comment_style)
      raise Puppet::ParseError, "puppet_managed: passed unknown comment_style (#{opts{'comment_style'}})"
    end

    if comment_methods[comment_style].has_key?(:prefix)
        prefix = comment_methods[comment_style][:prefix]
        managed_text.map! { |line| prefix + " " + line }
    end

    if comment_methods[comment_style].has_key?(:block_start)
      block_start = comment_methods[comment_style][:block_start]
      block_end = comment_methods[comment_style][:block_end]

      # Start with line continuation if we have one
      # (neccessary to do first, to avoid double prefixing)
      if comment_methods[comment_style].has_key?(:block_continuation)
        block_continuation = comment_methods[comment_style][:block_continuation]
        managed_text.map! { |line| block_continuation + " " + line }
      end

      # now add block start and block end
      managed_text.unshift(block_start)
      managed_text.push(block_end)

    end

    managed_text.map! { |item| item + "\n" }.join("")
  end
end
