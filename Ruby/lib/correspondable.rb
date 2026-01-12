
class XContext
    def initialize(writer, indent = 4)
        @writer = writer;
        @step = indent;        
        @depth = 0;
        @single_line = false;
        @text = TextWriter.new(self);
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
end

class XCounter
    def initialize(v = 0)
        @count = v;
    end
    attr_writer :data
    attr_writer :parent
    def next
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
    def attrs()
        return {}
    end
    def valid()
        @count == 0
    end
end

class ElementWriter
    def initialize(ctx, name, single_line = false, counter = XCounter.new(), &child)
        while(counter.valid())
            ctx.write_element(name, single_line, counter.attrs(), child);
            counter.next();
        end
    end
    def self.pop(ctx, name, single_line = false, counter = XCounter.new(), &child)
        while(counter.valid())
            ctx.write_element(name, single_line, counter.attrs(), child);
            counter.next();
        end
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
