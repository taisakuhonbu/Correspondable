require("./html.rb");

w = File.open("index.html", "w")
data = [
    ["<1-A>", "<1-B>", "<1-C>"],
    ["<2-A>", "<2-B>"],
    ["<3-A>", "<3-B>", "<3-C>", "<3-D>"],
];
ctx = XContext.new(w, data);

tr_counter = ctx.create_counter();
def tr_counter.attrs()
    if self % 2 == 0
        return {"class" => "even"};
    else
        return {"class" => "odd"};
    end
end
def tr_counter.valid?()
    return self < data().length();
end
td_counter = tr_counter.create_child();
def td_counter.content()
    dr = parent().as_index_of(data());
    return self.as_index_of(dr);
end
def td_counter.valid?()
    dr = parent().as_index_of(data());
    return self < dr.length();
end
code_attr = XCounter.new(class: "language-c");

HTML.pop(ctx){
    HEAD.pop(ctx){
        TITLE.pop(ctx, "Hello, world");
        CSS.pop(ctx, "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/styles/default.min.css");
        CSS.pop(ctx, "sample.css");
        SCRIPT.pop(ctx, "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/highlight.min.js");
        SCRIPT.pop(ctx){|t|
            t.w("hljs.highlightAll();");
        }
    }
    BODY.pop(ctx){
        DIV.pop(ctx){
            P.pop(ctx){|t|
                t.escaped = true;
                t.w("<em>Hello</em> world");
            }
        }
        HR.pop(ctx);
        TABLE.pop(ctx){
            TR.pop(ctx, tr_counter){
                TD.pop(ctx, true, td_counter){|t|
                    t.w(td_counter.content());
                }
            }
        }
        HR.pop(ctx);
        PRE.pop(ctx, true){
            CODE.pop(ctx, false, code_attr){|t|
                t.text_indent = 0;
                t.w <<'EOCODE'
#include <stdio.h>
int main()
{
    printf("Hello, world.");
}
EOCODE
            }
        }
    }
}

w.close()
