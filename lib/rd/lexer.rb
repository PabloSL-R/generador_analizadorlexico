module RD

  Token = Struct.new(:name, :value)
  Pattern = Struct.new(:name, :pattern, :block)
  
  class Lexer
    def initialize(&block)
      @patterns = []
      @tokens = []
      instance_eval(&block)
    end
    
    def lex(string)
      pos = 0
      len = string.length - 1 
      until pos > len
	m = @patterns.any? do |p|
	  n = p.pattern.match(string, pos)
	  if n
	    name = p.name
	    name = n[0] unless name
	    name = name.to_s
	    @tokens << Token.new (name, p.block.call(n.to_s))
	    pos += n[0].length
	    true 
	  else
	    false
	  end
      end
    end
    
    def white(expr, &block)
    end
    
    def token(pattern, &block)
      if pattern.is_a? Hash
	pattern, name = pattern.each.next
      else
	name = nil
      end
      
      block = Proc.new { |m| m } if block.nil?
      @patterns << Pattern.new(name,
                               Regexp.new("\\G(?:#{pattern.source})", pattern.options),
                               block)
    end
    
  end
end