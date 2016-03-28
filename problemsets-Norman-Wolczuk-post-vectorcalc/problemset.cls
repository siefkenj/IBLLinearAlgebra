\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{problemset}
              [2015/11/07 v0.1 class for typesetting problemsets]


% extend the article class
\LoadClass{article}


%%
%% LOAD DEPENDENCIES  
%%

	% the geometry package will make sure the pdf page gets set to the same size as \paperheight and \paperwidth
	% further, with these settings text will take up 100% of the page
	\RequirePackage[
		textwidth=\paperwidth, 
		textheight=\paperheight, 
		noheadfoot, 
		nomarginpar
		]{geometry} 	
	\RequirePackage[absolute]{textpos}
	\RequirePackage{everypage}
	\RequirePackage{xparse}
	\RequirePackage[usenames,dvipsnames]{xcolor}
	\RequirePackage{tcolorbox}
		\tcbuselibrary{skins}
	\RequirePackage{ifthen}
	\RequirePackage{titlesec}




%
% Set up the appropriate margins
%
	\pagestyle{empty}

	\def\probset@voffset{0pt}
	\def\probset@topmargin{10pt}
	\def\probset@headheight{12pt}
	\def\probset@headsep{10pt}
	\def\probset@footskip{30pt}

	\def\probset@hoffset{80pt}
	\def\probset@marginparsep{10pt}
	\def\probset@marginparwidth{35pt}

	% set all the latex values.  We need to addtolength
	% because geometry magically adjusted them so we start
	% out using all of the page's area; the actual values may
	% not be zero!
	\addtolength\voffset{\probset@voffset}
	\addtolength\topmargin{\probset@topmargin}
	\addtolength\headheight{\probset@headheight}
	\addtolength\headsep{\probset@headsep}
	\addtolength\footskip{\probset@footskip}

	% set the textheight correctly
	\addtolength\textheight{-\probset@voffset}
	\addtolength\textheight{-\probset@topmargin}
	\addtolength\textheight{-\probset@headheight}
	\addtolength\textheight{-\probset@headsep}
	\addtolength\textheight{-\probset@footskip}
	%\addtolength\textheight{-1in}

	\addtolength\hoffset{\probset@hoffset}
	\addtolength\marginparsep{\probset@marginparsep}
	\addtolength\marginparwidth{\probset@marginparwidth}

	% set the textwidth correctly
	\addtolength\textwidth{-\probset@hoffset}
	\addtolength\textwidth{-\probset@marginparsep}
	\addtolength\textwidth{-\probset@marginparwidth}
	%\addtolength\textwidth{-1in}



%\message{     MY MESSAGE \the\paperheight, \the\p@, \the\marginparwidth, \the\hoffset, \the\headheight, \the\topmargin, \the\textwidth}
%\message{     MY MESSAGE \the\marginparpush, \the\leftmargini}


%\AddEverypageHook{  % there cannot be any blank lines in this code!
%	\message{hi a page! \thepage}
%	% put the page in the upper right corner
%	\begin{textblock*}{\probset@marginparwidth}(\textwidth,0pt)
%		\begin{center}
%		\huge\sffamily  \thepage
%		\end{center}
%	\end{textblock*}
%}


% public commands
\newcommand{\sidetextformatting}{\sffamily\small}
\newcommand{\declareoutlinedbox}[5]{%
	% #1 = name of the box environment
	% #2 = full sidetext of the box environment
	% #3 = abbriviated sidetext of the box environment (if the box is short)
	% #4 = color of the outline of the box
	% #5 = emph color while inside the box
	\def\probset@sidetextabbrformatted{\sidetextformatting #3}
	\def\probset@sidetextformatted{\sidetextformatting #2}
	\settowidth{\probset@sidetextheight}{\ \probset@sidetextformatted\ \ }
	\probset@declareoutlinedboxwithlengths{#1}{#2}{#3}{#4}{#5}{\the\probset@sidetextheight}
}
% private commands
\newdimen\probset@boxheight 		% height of the box to see if we squish text
\newdimen\probset@sidetextheight 		% height of the box to see if we squish text
\newcommand{\probset@declareoutlinedboxwithlengths}[6]{%
	% #1 = name of the box environment
	% #2 = full sidetext of the box environment
	% #3 = abbriviated sidetext of the box environment (if the box is short)
	% #4 = color of the outline of the box
	% #5 = emph color while inside the box
	% #6 = height of the sidetext as a string
	
	%
	% Set up the style of the box and add it to tcolorbox's library of styles
	%
	\tcbset{box#1/.style={
		skin=enhanced jigsaw,
		boxrule=1pt,
		fonttitle=\bfseries\sffamily,coltitle=#5,colbacktitle=white,
		titlerule=0mm,
		colframe=#4,coltext=black,colback=white,
		top=2pt,bottom=2pt,bottomtitle=-5pt,
		attach boxed title to top left={yshift=-2mm, xshift=4mm},
		boxed title style={ boxrule=0pt, colframe=white },
		enlarge left by=-1cm-\kvtcb@right@rule,
		width=\linewidth+1cm,
		left=1cm-\kvtcb@left@rule*2-\kvtcb@boxsep,
		overlay={
		\begin{tcbclipinterior}
			\setlength{\probset@boxheight}{\tcb@natheight} % set the height of the box as a length so we can compare it with another length
			\setlength{\probset@sidetextheight}{#6}
			\ifthenelse{\lengthtest{\probset@sidetextheight > \probset@boxheight}}{
				\node[text=lightgray,rotate=90] at ([xshift=2.5mm]frame.west) {\sidetextformatting #3};
			}{
				\node[text=lightgray,rotate=90] at ([xshift=2.5mm]frame.west) {\sidetextformatting #2};
			}
		\end{tcbclipinterior}
		}
	}}
	
	%
	% Declare the new environment
	%
	\DeclareDocumentEnvironment{#1}{o}{
		\renewcommand{\emph}[1]{{
			\color{#5} \textbf{\textit{####1}}
		}}
		\IfNoValueTF{##1}{
			\begin{tcolorbox}[box#1, parbox=false]
		}{
			\begin{tcolorbox}[box#1, title=##1, parbox=false]
		}
	}{
		\end{tcolorbox}	
		\ignorespacesafterend
	}
}


%%
%% SET UP QUESTIONS AND PARTS ENVIRONMENTS
%%
	\newcounter{question}
	\newcounter{questionpart}

	\newcommand{\question}{%
		\addtocounter{question}{1}
		\def\@currentlabel{\thequestion} 	% make a \label command work after a question
		\noindent
		\makebox(.5,0)[lt]{
			\hspace{-2cm}
			\makebox(0,10)[lt]{\rule{1.4in}{.5pt}}
			\begin{minipage}[t]{1in}
				\vspace{-2pt}
				\color{gray}{\sffamily\large\thequestion}
			\end{minipage}
		}
		\nopagebreak
		\par
	}

	% the parts environment should act quite similarly to the
	% list environment, so we'll use the latex list environment
	% to create it
	\newcounter{partsitem}
	\newcounter{partsitemlast}
	\newcommand{\formatpartsitem}{%
		{\color{gray}{\sffamily\small\thequestion.\thepartsitem}}
	}
	\DeclareDocumentEnvironment{parts}{o}{
		\nopagebreak
		\begin{list}{\formatpartsitem}{
			\usecounter{partsitem}
			\setlength{\leftmargin}{0cm}
			\setlength{\itemsep}{0cm}
			\setlength{\topsep}{0cm}
		}
		% if we gave the [resume] argument, start counting from where we 
		% left off.
		\ifthenelse{ \equal{#1}{resume} }{
			\setcounter{partsitem}{\value{partsitemlast}}
		}{}
		% we'd like an sub-enumerate environments 
		% to act like they're nested, so advance
		% the level by one.
		\advance\@enumdepth\@ne
	}{
		\setcounter{partsitemlast}{\value{partsitem}}
		\end{list}%
	}




%%
%% SET UP PRESETS AND DEFAULT ENVIRONMENTS
%%
	\definecolor{defcolor}{rgb}{.05,.4,.15}
	\colorlet{defframecolor}{green!50!black}
\declareoutlinedbox{definition}{DEFINITION}{DEF}{defframecolor}{defcolor}
	\colorlet{thmcolor}{red!70!black}
	\colorlet{thmframecolor}{red!90!black}
\declareoutlinedbox{theorem}{THEOREM}{THM}{thmframecolor}{thmcolor}

\titleformat{\chapter}
  {\normalfont\sffamily\huge\color{blue}}
  {\thesection}{1em}{}
\titleformat{\section}
  {\normalfont\sffamily\Large\color{cyan}}
  {\thesection}{1em}{}
\titleformat{\subsection}
  {\normalfont\sffamily\large\color{cyan}}
  {\thesection}{1em}{}

\setlength{\parindent}{0cm}
\setlength{\parskip}{.17cm}
