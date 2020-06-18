#!/usr/bin/env sh

# This script is used for testing using Travis-CI
# It is intended to work on their VM set up: Ubuntu 14.04 LTS
# As such, the nature of the system is hard-coded
# A minimal current TL is installed adding only the packages that are
# required

# It is modified from https://github.com/josephwright/siunitx/blob/master/install.sh

# See if there is a cached verson of TL available
export PATH=/tmp/texlive/bin/x86_64-linux:$PATH
if ! command -v texlua > /dev/null; then
  # Obtain TeX Live
  wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
  tar -xzf install-tl-unx.tar.gz
  cd install-tl-20*

  # Install a minimal system
  ./install-tl --profile=../texlive.profile

  cd ..
fi

# Update tlmgr itself then all installed packages
tlmgr update --self --all --no-auto-install

# l3build itself
tlmgr install l3build

# Required to build plain and LaTeX formats:
# TeX90 plain for unpacking
tlmgr install latex-bin tex xetex

# Metafont
tlmgr install metafont mfware

# Dependencies of siunitx (have to be present in all cases)
tlmgr install amsmath graphics l3packages tools

# Dependencies
tlmgr install   \
  alphalph       \
  amsfonts       \
  atveryend      \
  babel-english  \
  babel-french   \
  babel-german   \
  babel-spanish  \
  bidi           \
  booktabs       \
  cancel         \
  caption        \
  carlisle       \
  collcell       \
  colortbl       \
  csquotes       \
  datatool       \
  dvips          \
  ec             \
  enumitem       \
  epstopdf-pkg   \
  fancyvrb       \
  hologo         \
  hycolor        \
  hyperref       \
  kvoptions      \
  koma-script    \
  libertine      \
  listings       \
  lualatex-math  \
  makeindex      \
  mathpazo       \
  mptopdf        \
  multirow       \
  pdftexcmds     \
  pgfplots       \
  psnfss         \
  opensans       \
  sansmath       \
  soulpos        \
  soulutf8       \
  stringenc      \
  translations   \
  underscore     \
  unicode-math   \
  was            \
  xcolor         \
  xtab           \
  microtype      \
  etoolbox       \
  geometry       \
  xparse         \
  ifthen         \
  tikz           \
  tcolorbox      \
  fancyhdr       \
  calc           \
  wrapfig        \
  marginnote     \
  mparhack       \
  marginfix      \
  indextools     \
  bookmark       \
  mathdesign     \
  fnpct          \
  bm             \
  systeme        \
  xspace         \
  textpos        \
  everypage      \
  environ        \
  titlesec       \
  changepage     \
  eso-pic        \
  multicol       \
  trimspaces     \
  pdfx           \
  datetime       \
  fmtcount       \
  lipsum         \
  mathtools      \
  tikz-cd        \
  zref           \
  expl3          \
  keyval         \
  ifpdf          \
  ifvtex         \
  ifxetex        \
  everyshi       \
  pgf            \
  pgfrcs         \
  pgfcore        \
  graphicx       \
  graphics       \
  trig           \
  pgfsys         \
  verbatim       \
  pgffor         \
  pgfkeys        \
  pgfmath        \
  ifluatex       \
  atbegshi       \
  infwarerr      \
  ltxcmds        \
  inputenc       \
  xkeyval        \
  fcprefix       \
  fcnumparser    \
  amsgen         \
  datetime-defaults \
  amsmath        \
  amstext        \
  amsbsy         \
  amsopn         \
  mdbch          \
  fontenc        \
  mhsetup        \
  caption3       \
  subcaption     \
  xpatch         \
  pdfescape      \
  hobsub-hyperref\
  hobsub-generic \
  auxhook        \
  url            \
  rerunfilecheck \
  l3keys2e       \
  scrlfile       \
  xstring        \
  xfor           \
  substr         \
  datatool-base  \
  datatool-fp    \
  fp             \
  defpattern     \
  fp-basic       \
  fp-addons      \
  fp-snap        \
  fp-exp         \
  fp-trigo       \
  fp-pas         \
  fp-random      \
  fp-eqn         \
  fp-upn         \
  fp-eval        \
  epstopdf-base  \
  grfext         \
  nameref        \
  ly1            \
  courier        \
  charter        \
  colorprofiles  \
  gettitlestring 

## original package list
#  alphalph      \
#  amsfonts      \
#  atveryend     \
#  babel-english \
#  babel-french  \
#  babel-german  \
#  babel-spanish \
#  bidi          \
#  booktabs      \
#  cancel        \
#  caption       \
#  carlisle      \
#  collcell      \
#  colortbl      \
#  csquotes      \
#  datatool      \
#  dvips         \
#  ec            \
#  enumitem      \
#  epstopdf-pkg  \
#  fancyvrb      \
#  hologo        \
#  hycolor       \
#  hyperref      \
#  kvoptions     \
#  koma-script   \
#  libertine     \
#  listings      \
#  lualatex-math \
#  makeindex     \
#  mathpazo      \
#  mptopdf       \
#  multirow      \
#  pdftexcmds    \
#  pgfplots      \
#  psnfss        \
#  opensans      \
#  sansmath      \
#  soulpos       \
#  soulutf8      \
#  stringenc     \
#  translations  \
#  underscore    \
#  unicode-math  \
#  was           \
#  xcolor        \
#  xtab          \
#  microtype     \
#  etoolbox      \
#  geometry      \
#  enumitem      \
#  xparse        \
#  ifthen        \
#  caption       \
#  tikz          \
#  tcolorbox     \
#  fancyhdr      \
#  calc          \
#  wrapfig       \
#  marginnote    \
#  mparhack      \
#  marginfix     \
#  indextools    \
#  bookmark      \
#  mathdesign    \
#  fnpct         \
#  bm            \
#  systeme       \
#  datatool      \
#  xspace        \
#  pgfplots      \
#  textpos       \
#  xparse        \
#  everypage     \
#  environ       \
#  titlesec      \
#  changepage    \
#  eso-pic       \
#  multicol      \
#  trimspaces    \
#  pdfx          \
#  datetime      \
#  fmtcount      \
#  lipsum        \
#  mathtools     \
#  tikz-cd       \
#  zref

# autogenerated list
#expl3	\
#geometry	\
#keyval	\
#ifpdf	\
#ifvtex	\
#ifxetex	\
#textpos	\
#everyshi	\
#everypage	\
#xparse	\
#environ	\
#trimspaces	\
#xcolor	\
#tcolorbox	\
#pgf	\
#pgfrcs	\
#pgfcore	\
#graphicx	\
#graphics	\
#trig	\
#pgfsys	\
#pgfcomp-version-0-65	\
#pgfcomp-version-1-18	\
#verbatim	\
#etoolbox	\
#tikz	\
#pgffor	\
#pgfkeys	\
#pgfmath	\
#ifluatex	\
#ifthen	\
#titlesec	\
#changepage	\
#eso-pic	\
#atbegshi	\
#infwarerr	\
#ltxcmds	\
#multicol	\
#inputenc	\
#datetime	\
#fmtcount	\
#xkeyval	\
#fcprefix	\
#fcnumparser	\
#amsgen	\
#datetime-defaults	\
#amsmath	\
#amstext	\
#amsbsy	\
#amsopn	\
#lipsum	\
#mathdesign	\
#mdbch	\
#fontenc	\
#microtype	\
#mathtools	\
#calc	\
#mhsetup	\
#enumitem	\
#caption	\
#caption3	\
#subcaption	\
#fancyhdr	\
#wrapfig	\
#marginnote	\
#mparhack	\
#marginfix	\
#indextools	\
#pdftexcmds	\
#xpatch	\
#bookmark	\
#pdfescape	\
#hyperref	\
#hobsub-hyperref	\
#hobsub-generic	\
#auxhook	\
#kvoptions	\
#url	\
#rerunfilecheck	\
#fnpct	\
#l3keys2e	\
#scrlfile	\
#translations	\
#bm	\
#systeme	\
#xstring	\
#datatool	\
#xfor	\
#substr	\
#datatool-base	\
#datatool-fp	\
#fp	\
#defpattern	\
#fp-basic	\
#fp-addons	\
#fp-snap	\
#fp-exp	\
#fp-trigo	\
#fp-pas	\
#fp-random	\
#fp-eqn	\
#fp-upn	\
#fp-eval	\
#xspace	\
#pgfplots	\
#epstopdf-base	\
#grfext	\
#nameref	\
#gettitlestring
# Keep no backups (not required, simply makes cache bigger)
tlmgr option -- autobackup 0
