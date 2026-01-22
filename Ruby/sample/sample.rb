require("./html.rb");

w = File.open("index.html", "w")
data = [
    ["<1-A>", "<1-B>", "<1-C>"],
    ["<2-A>", "<2-B>"],
    ["<3-A>", "<3-B>", "<3-C>", "<3-D>"],
];
ctx = XContext.new(w , data);
HTML.pop(ctx){
    HEAD.pop(ctx){
        TITLE.pop(ctx, "Hello, world");
        SCRIPT.pop(ctx, "index.js");
    }
    BODY.pop(ctx){
        DIV.pop(ctx){
            P.pop(ctx){|t|
                t.w("<em>Hello</em> world", true);
            }
        }
        HR.pop(ctx);
        DIV.pop(ctx){
            TABLE.pop(ctx){
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
                TR.pop(ctx, tr_counter){
                    td_counter = tr_counter.create_child();
                    def td_counter.content()
                        dr = parent().as_index_of(data());
                        return self.as_index_of(dr);
                    end
                    def td_counter.valid()
                        dr = parent().as_index_of(data());
                        return self < dr.length;
                    end
                    TD.pop(ctx, true, td_counter){|t|
                        t.w(td_counter.content());
                    }
                }
            }
        }
    }
}
w.close()
