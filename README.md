# Summary

A converter between Quip topics and AsciiDoc files for "[Razbor Poletov](https://razborpoletov.com/)."

# How to install and run it

0. Clone this code, optionally `chmod 755 ./quip-to-adoc.rb`
1. Install gems
    * `gem install rationalist` (POSIX command line parser, [GitHub repo](https://github.com/janlelis/rationalist))
    * `gem install httparty` (Simple HTTP wrapper, [GitHub repo](https://github.com/jnunemaker/httparty))
    * `gem install reverse_markdown` (HTML to Markdown converter, [GitHub repo](https://github.com/xijo/reverse_markdown))
    * `gem install kramdown` (Markdown parser and converter, [GitHub repo](https://github.com/gettalong/kramdown))
    * `gem install kramdown-asciidoc` (Asciidoc extension for Kramdown, [GitHub repo](https://github.com/asciidoctor/kramdown-asciidoc))
    * `gem install asciidoctor` (Official Asciidoctor gem, [GitHub repo](https://github.com/asciidoctor/asciidoctor))
2. Get an API token here: https://quip.com/dev/token
3. Get a topic ID from URL like this: `https://quip.com/2RL1A64NqA2N`
4. Run script: 
    ```
    ruby quip-to-adoc.rb \
        --id=2RL1A64NqA2N \
        --token="Y111111112222222|3333333333|4444444444444444444555555555555666667/8/999=" \
        --http_debug=false \
        --adoc=C:/temp/adoc.adoc \
        --html=C:/temp/html.html \
        --quip=C:/temp/quip.html \
        --md=C:/temp/md.md
    ```

# Options

* `id` and `token` are required;
* when `adoc` exists, it prints everything to a file, into stdout otherwise;
* everything else is optional and can be used for debugging:
    * `http_debug` enables internal debugging in **httparty**
    * `html` is a reference HTML that can be produced from `adoc` via official Asciidoctor gem;
    * `quip` is a raw response from Quip site, only body part of it
    * `md` is an intermediate representation in the chain: Quip HTML -> Markdown -> Asciidoc -> \[Asciidoctor HTML\]
