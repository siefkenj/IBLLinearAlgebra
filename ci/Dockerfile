# Base image for LaTeX CI
FROM ghcr.io/xu-cheng/texlive-small:latest
WORKDIR /workdir

# Install additional LaTeX packages
RUN tlmgr update --self
# tlmgr --force install textpos everypage enumitem ifthen tikz wrapfig marginnote mparhack marginfix indextools nicematrix fnpct systeme datatool pgfplots environ tcolorbox tikzfill pdfcol titlesec changepage pdfx datetime fmtcount lipsum mathdesign tikz-cd translations xstring ly1 hyperxmp ifmtarg luacode
RUN tlmgr --force install \
    textpos \
    everypage \
    enumitem \
    wrapfig \
    marginnote \
    mparhack \
    marginfix \
    indextools \
    nicematrix \
    fnpct \
    systeme \
    datatool \
    pgfplots \
    environ \
    tcolorbox \
    tikzfill \
    pdfcol \
    titlesec \
    changepage \
    pdfx \
    datetime \
    fmtcount \
    lipsum \
    mathdesign \
    tikz-cd \
    translations \
    xstring \
    ly1 \
    hyperxmp \
    ifmtarg \
    luacode
    
# Set a custom prompt
ENV PS1="\[\033[01;32m\]IBLLinearAlgebra\[\033[00m\]:\[\033[01;35m\]\w\[\033[00m\] $ "
