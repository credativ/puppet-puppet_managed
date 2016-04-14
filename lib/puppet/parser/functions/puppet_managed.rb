module Puppet::Parser::Functions
  newfunction(:puppet_managed, :type => :rvalue) do |args|
    comment_methods = {
      'hash'        => { :prefix => '#' },
      'sql'         => { :prefix => '--' },
      'percent'     => { :prefix => '%' },
      'vim'         => { :prefix => '"' },


      'xml'         => {
        :block_start        => '<!--',
        :block_end          => '-->',
        :block_continuation => ''
      },

      'c-block'     => {
        :block_start        => '/*',
        :block_end          => '  */',
        :block_continuation => '  *'
      },
    }
    opts    = {
      'filename'        => nil,
      'comment_style'   => 'hash',
      'verbose'         => false,
      'prefix'          => nil,
    }

    # The default managed by puppet text
    managed_text    = ['MANAGED BY PUPPET']
    prefix          = ''
    block_comment   = false

    unless args.empty?
      user_provided_opts = args.shift
      opts.merge!(user_provided_opts)
    end

    comment_style = opts['comment_style']
    unless comment_methods.include?(comment_style)
      raise Puppet::ParseError, "puppet_managed: passed unknown comment_style (#{opts['comment_style']})"
    end
    comment_method = comment_methods[comment_style]

    if ! opts['prefix'].nil?
      debug("comment_style overriden, because prefix is in args")
      prefix = opts['prefix']
    elsif comment_method.has_key?(:prefix)
      block_comment = false
      prefix        = comment_method[:prefix]
    elsif comment_method.has_key?(:block_start)
      block_comment = true
    end


    if opts['verbose']
      if opts['filename'].nil?
        raise ArgumentError, "puppet_managed: verbose requires the filename option to be set"
      end

      # add empty line add start
      managed_text.unshift('')

      # the rest is *after* the "managed by puppet" first line
      managed_text.push('')
      managed_text.push("Class: #{lookupvar('name')}")
      managed_text.push("Path: #{opts['filename']}")
      managed_text.push('')
    end

    if block_comment
      block_start   = comment_method[:block_start]
      block_end     = comment_method[:block_end]

      # Start with block continuation if we have one
      # (neccessary to do first, to avoid double prefixing)
      if comment_method.has_key?(:block_continuation)
        block_continuation = comment_methods[comment_style][:block_continuation]
        managed_text.map! { |line| block_continuation + " " + line }
      end

      # now add block start and block end
      managed_text.unshift(block_start)
      managed_text.push(block_end)

    else
      managed_text.map! { |line| prefix + " " + line }
    end

    managed_text.map! { |item| item + "\n" }.join("")
  end
end
