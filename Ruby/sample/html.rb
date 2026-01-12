$: << "../lib/";
require("correspondable");


class HTML < ElementWriter
    def self.pop(ctx, &child)
        super(ctx, "html")
    end
end

class HEAD < ElementWriter
    def self.pop(ctx, &child)
        super(ctx, "head");
    end
end

class TITLE < ElementWriter
    def self.pop(ctx, title)
        super(ctx, "title", true){|t|
            t.w(title);
        }
    end
end

class SCRIPT < ElementWriter
    def self.pop(ctx, src)
        c = XCounter.new()
        def c.src=(src)
            @src = src;
        end
        c.src = src;
        def c.attrs()
            return {"src" => @src}
        end
        super(ctx, "script", true, c){
        }
    end
end

class BODY < ElementWriter
    def self.pop(ctx, &child)
        super(ctx, "body");
    end
end

class DIV < ElementWriter
    def self.pop(ctx, &child)
        super(ctx, "div");
    end
end

class P < ElementWriter
    def self.pop(ctx, &child)
        super(ctx, "p");
    end
end

class HR < ElementWriter
    def self.pop(ctx)
        super(ctx, "hr")
    end
end

class TABLE < ElementWriter
    def self.pop(ctx, &child)
        super(ctx, "table");
    end
end

class TR < ElementWriter
    def self.pop(ctx, counter, &child)
        super(ctx, "tr", false, counter);
    end
end

class TD < ElementWriter
    def self.pop(ctx, single_line, counter, &child)
        super(ctx, "td", single_line, counter);
    end
end
