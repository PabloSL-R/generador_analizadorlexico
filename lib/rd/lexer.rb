module RD
  class Token
  end
  
  Pattern = Struct.new(:name, :pattern, :block)
  
  class Lexer
    def initialize(&block)
      @patterns = []
      instance_eval(&block)
    end
    
    def lex(expr)
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
                               Regexp.new('\\G(?:'+pattern.source+')', pattern.options),
                               block)
    end
    
  end
end