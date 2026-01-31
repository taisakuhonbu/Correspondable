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

class CSS < ElementWriter
    def self.pop(ctx, href)
        c = XCounter.new()
        c.attr("rel", "stylesheet");
        c.attr("href", href)
        super(ctx, "link", true, c);
    end
end

class SCRIPT < ElementWriter
    def self.pop(ctx, src = nil)
        c = XCounter.new()
        if src
            c.attr("src", src)
            super(ctx, "script", true, c){
            }
        else
            super(ctx, "script", false, c);
        end
    end
end

class BODY < ElementWriter
    def self.pop(ctx, &child)
        super(ctx, "body");
    end
end

class H1 < ElementWriter
    def self.pop(ctx, heading, &child)
        super(ctx, "h1", true){|t|
            t.w(heading);
        }
    end
end
class H2 < ElementWriter
    def self.pop(ctx, heading, &child)
        super(ctx, "h2", true){|t|
            t.w(heading);
        }
    end
end
class H3 < ElementWriter
    def self.pop(ctx, heading, &child)
        super(ctx, "h3", true){|t|
            t.w(heading);
        }
    end
end
class H4 < ElementWriter
    def self.pop(ctx, heading, &child)
        super(ctx, "h4", true){|t|
            t.w(heading);
        }
    end
end
class H5 < ElementWriter
    def self.pop(ctx, heading, &child)
        super(ctx, "h5", true){|t|
            t.w(heading);
        }
    end
end
class H6 < ElementWriter
    def self.pop(ctx, heading, &child)
        super(ctx, "h6", true){|t|
            t.w(heading);
        }
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

class BR < ElementWriter
    def self.pop(ctx)
        super(ctx, "br", true)
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

class PRE < ElementWriter
    def self.pop(ctx, single_line, &child)
        super(ctx, "pre", single_line);
    end
end

class CODE < ElementWriter
    def self.pop(ctx, single_line, counter, &child)
        super(ctx, "code", single_line, counter);
    end
end
