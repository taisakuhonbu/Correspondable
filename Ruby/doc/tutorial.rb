require("../sample/html.rb")

data = [
    ["<1-A>", "<1-B>", "<1-C>"],
    ["<2-A>", "<2-B>"],
    ["<3-A>", "<3-B>", "<3-C>", "<3-D>"],
];
w = File.open("tutorial.html", "w");
ctx = XContext.new(w , data);
code_attr = XCounter.new(class: "language-ruby");
HTML.pop(ctx){
    HEAD.pop(ctx){
        TITLE.pop(ctx, "[Correspondable docs] tutorial");
        CSS.pop(ctx, "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/styles/default.min.css");
        SCRIPT.pop(ctx, "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/highlight.min.js");
        SCRIPT.pop(ctx){|t|
            t.w("hljs.highlightAll();");
        }
        CSS.pop(ctx, "tutorial.css");
    }
    BODY.pop(ctx){
        H1.pop(ctx, "Correspondable tutorial");
        P.pop(ctx){|t|
            t.w("XML を書き出すプログラムソースコードを、XML と同じインデントで書くことができます。");
            BR.pop(ctx);
            t.w("HTML を書き出すサンプルで解説します。");
        }
        H2.pop(ctx, "要素クラスを作る");
        P.pop(ctx){|t|
            t.w("ElementWriter を継承してクラスメソッドの pop をオーバーライドします。" +
                "最初の引数はコンテキストで、全体をコントールして XML を組み立てます。");
        }
        H3.pop(ctx, "属性を持たない空要素");
        P.pop(ctx){|t|
            t.w("hr 要素を作ります。要素名を親に渡すだけです。");
        }
        PRE.pop(ctx, true){
            CODE.pop(ctx, false, code_attr){|t|
                t.text_indent = 0;
                t.w <<-'EOC'
class HR < ElementWriter
    def self.pop(ctx)
        super(ctx, "hr")
    end
end
                EOC
            }
        }
        H3.pop(ctx, "属性がなくて、単純なテキストを持つ要素");
        P.pop(ctx){|t|
            t.w("title 要素を作ります。pop の引数でテキストを取ってしまいましょう。" +
                "true は single_line です。改行なしで要素を書き出すように指示しています。" + 
                "ブロックの引数は TextWriter です。w メソッドに文字列を渡します。通常は XML エスケープをします。");
        }
        PRE.pop(ctx, true){
            CODE.pop(ctx, false, code_attr){|t|
                t.text_indent = 0;
                t.w <<-'EOC'
class TITLE < ElementWriter
    def self.pop(ctx, title)
        super(ctx, "title", true){|t|
            t.w(title);
        }
    end
end
                EOC
            }
        }
        H3.pop(ctx, "一般的な要素");
        P.pop(ctx){|t|
            t.w("body 要素を作ります。属性は持たせていません。" +
                "テキストと子要素を作れるようにするため、ブロックを引数にとれるようにします。");
        }
        PRE.pop(ctx, true){
            CODE.pop(ctx, false, code_attr){|t|
            t.text_indent = 0;
            t.w <<-'EOC'
class BODY < ElementWriter
    def self.pop(ctx, &child)
        super(ctx, "body");
    end
end
                EOC
            }
        }
        H3.pop(ctx, "決まった属性を持つ要素");
        P.pop(ctx){|t|
            t.w("スタイルシート指定の要素を作ります。引数で参照先を取りましょう。" + 
                "属性を作るには、XCounter が必要です。コンストラクターでキーと値を並べます。" +
                "作ったら親に渡します。");
        }
        PRE.pop(ctx, true){
            CODE.pop(ctx, false, code_attr){|t|
            t.text_indent = 0;
            t.w <<-'EOC'
class CSS < ElementWriter
    def self.pop(ctx, href)
        c = XCounter.new(rel: "stylesheet", href: href);
        super(ctx, "link", true, c);
    end
end
                EOC
            }
        }
        H3.pop(ctx, "単純でない属性を持つ要素");
        P.pop(ctx){|t|
            t.w("tr 要素を作ります。縞模様にしたいことがあるでしょう。" +
                "XCounter を外からもらいます。これは繰り返しにも使います。");
        }
        PRE.pop(ctx, true){
            CODE.pop(ctx, false, code_attr){|t|
            t.text_indent = 0;
            t.w <<-'EOC'
class TR < ElementWriter
    def self.pop(ctx, counter, &child)
        super(ctx, "tr", false, counter);
    end
end
                EOC
            }
        }
        H3.pop(ctx, "属性かテキストか、の要素");
        P.pop(ctx){|t|
            t.w("script 要素を作ります。ブロックを取れるようにしますが、あるかないかで分岐します。" +
                "src があった場合は、何もしないブロックをつけます。これで開くタグと閉じるタグになります。");
        }
        PRE.pop(ctx, true){
            CODE.pop(ctx, false, code_attr){|t|
            t.text_indent = 0;
            t.w <<-'EOC'
class SCRIPT < ElementWriter
    def self.pop(ctx, src = nil, &child)
        c = XCounter.new(src: src);
        if src
            super(ctx, "script", true, c){
            }
        else
            super(ctx, "script", false, c);
        end
    end
end
                EOC
            }
        }
        H2.pop(ctx, "HTML を書き出すプログラム")
        P.pop(ctx){|t|
            t.w("作ったクラスを使って、HTML を書き出すプログラムを作りましょう。" +
                "繰り返しの解説をするために、表を作ります。このデータを使います。");
        }
        PRE.pop(ctx, true){
            CODE.pop(ctx, false, code_attr){|t|
                t.text_indent = 0;
                t.w <<-'EOC'
data = [
    ["<1-A>", "<1-B>", "<1-C>"],
    ["<2-A>", "<2-B>"],
    ["<3-A>", "<3-B>", "<3-C>", "<3-D>"],
];
                EOC
            }
        }
        H3.pop(ctx, "XContext を作る");
        P.pop(ctx){|t|
            t.w("テキストファイルライターを作ります。");
        }
        PRE.pop(ctx, true){
            CODE.pop(ctx, false, code_attr){|t|
                t.text_indent = 0;
                t.w <<-'EOC'
w = File.open("tutorial.html", "w")
                EOC
            }
        }
        P.pop(ctx){|t|
            t.w("それを使って XContext を作ります。" +
                "渡した data は、XContext から作った XCounter の data() メソッドで取得できます。");
        }
        PRE.pop(ctx, true){
            CODE.pop(ctx, false, code_attr){|t|
                t.text_indent = 0;
                t.w <<-'EOC'
ctx = XContext.new(w , data);
                EOC
            }
        }
        H3.pop(ctx, "XCounter で繰返しを制御");
        P.pop(ctx){|t|
            t.escaped = true;
            t.w("tr を繰り返して作るための XCounter を作ります。<br/>");
            t.w("奇数行と偶数行で色を変えるために、CSS の class を切り替えます。" +
                "attrs メソッドをオーバーライドして class 属性の値を渡す辞書を奇数偶数で違うものにします。<br/>");
            t.w("繰り返しの終了を知らせる valid? メソッドもオーバーライドします。" +
                "data の（１次）配列の長さに達したら false を返すようにします。");
        }
        PRE.pop(ctx, true){
            CODE.pop(ctx, false, code_attr){|t|
                t.text_indent = 0;
                t.w <<-'EOC'
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
                EOC
            }
        }
        P.pop(ctx){|t|
            t.escaped = true;
            t.w("td を繰り返して作るための XCounter を作ります。" +
                "２次元配列を扱うので、親カウンターの子供として作ります。<br/>");
            t.w("テキストとして書き出すデータを返すメソッドを新規に作ります。" +
                "１次元目のカウントのための親カウンターは parent() でとれます。" +
                "コンテキストに渡した全体データは、コンテキストから親カウンターを経由して、data() で取得できます。<br/>");
            t.w("繰り返しの終了を知らせる valid? メソッドのオーバーライドも作ります。" +
                "２次元目の配列の長さに達したら false を返すようにします。");
        }
        PRE.pop(ctx, true){
            CODE.pop(ctx, false, code_attr){|t|
                t.text_indent = 0;
                t.w <<-'EOC'
td_counter = tr_counter.create_child();
def td_counter.content()
    dr = parent().as_index_of(data());
    return self.as_index_of(dr);
end
def td_counter.valid?()
    dr = parent().as_index_of(data());
    return self < dr.length();
end
                EOC
            }
        }
        H3.pop(ctx, "いろいろな属性のための XCounter");
        P.pop(ctx){|t|
            t.escaped = true;
            t.w("必須でない属性をたくさん持つ要素は、XCounter を外からもらうようにしておきます。<br/>");
            t.w("（属性が沢山ある要素ではありませんが）コードハイライトを確実にするために言語を知らせる属性です。");
        }
        PRE.pop(ctx, true){
            CODE.pop(ctx, false, code_attr){|t|
                t.text_indent = 0;
                t.w <<-'EOC'
code_attr = XCounter.new(class: "language-c");
                EOC
            }
        }
        H3.pop(ctx, "基本構造を作る");
        P.pop(ctx){|t|
            t.w("子要素をブロックの中で pop します。");
        }
        PRE.pop(ctx, true){
            CODE.pop(ctx, false, code_attr){|t|
                t.text_indent = 0;
                t.w <<-'EOC'
HTML.pop(ctx){
    HEAD.pop(ctx){
    }
    BODY.pop(ctx){
    }
}
                EOC
            }
        }
        H3.pop(ctx, "テキストを引数でとるようにした要素を作る");
        P.pop(ctx){|t|
            t.w("title 要素を作る TITLE クラスを pop します。");
        }
        PRE.pop(ctx, true){
            CODE.pop(ctx, false, code_attr){|t|
                t.text_indent = 0;
                t.w <<-'EOC'
    HEAD.pop(ctx){
        TITLE.pop(ctx, "Hello, world");
                EOC
            }
        }
        H3.pop(ctx, "属性を引数でとるようにした要素を作る");
        P.pop(ctx){|t|
            t.w("css を指定します。テキストを引数でとる場合と同じです。");
        }
        PRE.pop(ctx, true){
            CODE.pop(ctx, false, code_attr){|t|
                t.text_indent = 0;
                t.w <<-'EOC'
    HEAD.pop(ctx){
        CSS.pop(ctx, "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/styles/default.min.css");
        CSS.pop(ctx, "sample.css");
                EOC
            }
        }
        H3.pop(ctx, "特殊な要素 script を作る");
        P.pop(ctx){|t|
            t.escaped = true;
            t.w("src 属性で指定する場合はそれを引数で指定します。<br/>" +
                "スクリプトを直接書く場合は、ブロックで TextWriter を受け取って、w メソッドを使います。");
        }
        PRE.pop(ctx, true){
            CODE.pop(ctx, false, code_attr){|t|
                t.text_indent = 0;
                t.w <<-'EOC'
    HEAD.pop(ctx){
        SCRIPT.pop(ctx, "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/highlight.min.js");
        SCRIPT.pop(ctx){|t|
            t.w("hljs.highlightAll();");
        }
                EOC
            }
        }
        H3.pop(ctx, "タグを有効にしたテキスト");
        P.pop(ctx){|t|
            t.w("TextWriter は XML エスケープをしないようにすることができます。" +
                "escaped を true にします。");
        }
        PRE.pop(ctx, true){
            CODE.pop(ctx, false, code_attr){|t|
                t.text_indent = 0;
                t.w <<-'EOC'
    BODY.pop(ctx){
        DIV.pop(ctx){
            P.pop(ctx){|t|
                t.escaped = true;
                t.w("<em>Hello</em> world");
            }
                EOC
            }
        }
        H3.pop(ctx, "空要素を作る");
        P.pop(ctx){|t|
            t.w("コンテキストだけが必要です。");
        }
        PRE.pop(ctx, true){
            CODE.pop(ctx, false, code_attr){|t|
                t.text_indent = 0;
                t.w <<-'EOC'
    BODY.pop(ctx){
        HR.pop(ctx);
                EOC
            }
        }
        H3.pop(ctx, "繰り返して要素を作る");
        P.pop(ctx){|t|
            t.escaped = true;
            t.w("tr 用と td 用の XCounter を引数で渡します。<br/>");
            t.w("TD ではブロックを作って TextWriter にテキストを渡します。" +
                "td 用の XCounter に作ったテキストを返す特異メソッドを使います。");
        }
        PRE.pop(ctx, true){
            CODE.pop(ctx, false, code_attr){|t|
                t.text_indent = 0;
                t.w <<-'EOC'
    BODY.pop(ctx){
        TABLE.pop(ctx){
            TR.pop(ctx, tr_counter){
                TD.pop(ctx, true, td_counter){|t|
                    t.w(td_counter.content());
                }
            }
        }
                EOC
            }
        }
        H3.pop(ctx, "プログラムコードを紹介する要素");
        P.pop(ctx){|t|
            t.escaped = true;
            t.w("最後はインデントを故意にずらす記述です。")
            t.w("pre と code を使います。<br/>");
            t.w("この場合の pre は code 要素を一つとるだけなので、シングルラインにします。<br/>");
            t.w("テキストにもインデントが入るので、pre ではこれをとらないと、左側に大きな隙間ができてしまいます。" +
                "これを避けるため TextWriter に text_indent でインデントを変更させます。");
        }
        PRE.pop(ctx, true){
            CODE.pop(ctx, false, code_attr){|t|
                t.text_indent = 0;
                t.w <<-'EOC'
    BODY.pop(ctx){
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
                EOC
            }
        }
    }
}
