
class XContext
    def initialize(writer, data = nil, indent = 4, head_index: 0)
        @writer = writer;
        @data = data;
        @step = indent;
        @depth = 0;
        @head_index = head_index;
        @single_line = false;
        @text = TextWriter.new(self);
        @current = XCounter.new();
        @current.parent = @current;
    end

    def data()
        return @data;
    end

    def head_index()
        return @head_index;
    end

    def write_element(name, single_line, attrs, child)
        if @single_line == false
            @writer.write(" " * @depth * @step);
        end
        prev_sl = @single_line
        @single_line  = single_line
        @writer.write("<" + name);
        attrs.each() do |k, v|
            @writer.write(" " + k + "=");
            @writer.write(v.encode(:xml => :attr));
        end
        if child
            @writer.write(">");
            if single_line == false
                @writer.write("\n");
                @depth += 1;
            end
            child.call(@text)
            if single_line == false
                @depth -= 1;
                @writer.write(" " * @depth * @step);
            end
            @writer.write("</" + name + ">");
        else
            @writer.write("/>");
        end
        @single_line = prev_sl
        if @single_line == false
            @writer.write("\n");
        end
    end

    def write_text(content, escaped)
        if @single_line == false
            @writer.write(" " * (@depth * @step));
        end
        if escaped
            @writer.write(content);
        else
            @writer.write(content.encode(:xml => :text));
        end
        if @single_line == false
            @writer.write("\n");
        end
    end

    def create_counter()
        c = XCounter.new(self);
        c.parent = @current;
        @curent = c;
        return c;
    end
end

class XCounter
    def initialize(ctx = nil)
        @context = ctx;
        if ctx
            @head_index = ctx.head_index();
        else
            @head_index = 0;
        end
        @count = @head_index;
    end
    attr_accessor :parent;
    def create_child()
        c = XCounter.new(@context);
        c.parent = self;
        return c;
    end
    
    def next()
        @count += 1;
    end
 
    def < (limit)
        return @count < limit;
    end
    def == (count)
        return @count == count;
    end
    def % (mod)
        return @count % mod
    end
    def as_index_of(a)
        return a[@count];
    end

    def count()
        return @count;
    end

    def data()
        return @context.data;
    end

    def attrs()
        return {}
    end

    def valid?()
        return @count == @head_index;
    end

    def reset()
        @count = @head_index;
        return false;
    end
end

class ElementWriter
    def self.pop(ctx, name, single_line = false, counter = XCounter.new(), &child)
        while(counter.valid?())
            ctx.write_element(name, single_line, counter.attrs(), child);
            counter.next();
        end
        counter.reset();
    end
end

class TextWriter
    def initialize(ctx)
        @context = ctx
    end
    def w(content, escaped = false)
        @context.write_text(content, escaped)
    end
end
