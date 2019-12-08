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
%		textwidth=\paperwidth, 
%		textheight=\paperheight, 
%		noheadfoot, 
%		nomarginpar
		]{geometry} 	
	\RequirePackage[absolute]{textpos}
	\RequirePackage{everypage}
	\RequirePackage{xparse}
	\RequirePackage{environ}
	\RequirePackage[usenames, dvipsnames, cmyk, hyperref]{xcolor}
	\RequirePackage{tcolorbox}
		\tcbuselibrary{skins}
		\tcbuselibrary{breakable}
	\RequirePackage{ifthen}
	\RequirePackage{titlesec}
	\RequirePackage{changepage}
	\RequirePackage{eso-pic} % replaces `everyshi` to draw borders on the modules
	\RequirePackage{multicol}




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


	\geometry{top=.25in,
		headsep=0in, 
		headheight=0in, 
		left=.9in, 
		bottom=.3in, 
		footskip=0in,
		marginparsep=5pt, 
		marginparwidth=2in,
		right=10pt,
		includeall}

	% command to set even and odd page margins
	% for book printing.
	\def\setbookgeometry{\geometry{top=.4in,
		headsep=0in, 
		headheight=0in, 
		left=1.5in, 
		bottom=.5in, 
		footskip=0in,
		marginparsep=5pt, 
		marginparwidth=.8in,
		right=10pt,
		includeall,
		twoside=true}}
	% set all the latex values.  We need to addtolength
	% because geometry magically adjusted them so we start
	% out using all of the page's area; the actual values may
	% not be zero!
%	\addtolength\voffset{\probset@voffset}
%	\addtolength\topmargin{\probset@topmargin}
%	\addtolength\headheight{\probset@headheight}
%	\addtolength\headsep{\probset@headsep}
%	\addtolength\footskip{\probset@footskip}
%
%	% set the textheight correctly
%	\addtolength\textheight{-\probset@voffset}
%	\addtolength\textheight{-\probset@topmargin}
%	\addtolength\textheight{-\probset@headheight}
%	\addtolength\textheight{-\probset@headsep}
%	\addtolength\textheight{-\probset@footskip}
%	%\addtolength\textheight{-1in}
%
%	\addtolength\hoffset{\probset@hoffset}
%	\addtolength\marginparsep{\probset@marginparsep}
%	\addtolength\marginparwidth{\probset@marginparwidth}
%
%	% set the textwidth correctly
%	\addtolength\textwidth{-\probset@hoffset}
%	\addtolength\textwidth{-\probset@marginparsep}
%	\addtolength\textwidth{-\probset@marginparwidth}
%	%\addtolength\textwidth{-1in}



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
		\renewcommand{\emph}[1]{{%
			\color{#5} \textbf{\textit{####1}}%
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
		\pagebreak[3]
		\noindent
		\makebox(.5,0)[lt]{
			\hspace{-2cm}
			\makebox(0,10)[lt]{\rule{1.4in}{.5pt}}
			\begin{minipage}[t]{1in}
				\vspace{-2pt}
				\color{gray}{\sffamily\large\thequestion}
			\end{minipage}
		}%
		\addcontentsline{toc}{subsection}{\thequestion}%
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
	\DeclareDocumentEnvironment{solution}{o}{
		\nopagebreak
		%\par
		\color{cyan}
		\ifthenelse{ \equal{#1}{inline} }{}{
			\begin{adjustwidth}{1cm}{}
		}
	}{%
		\ifthenelse{ \equal{#1}{inline} }{}{
			\end{adjustwidth}
		}
	}
	\DeclareDocumentEnvironment{goals}{o}{
		\footnotesize\sffamily\parskip=1.5mm%
		\begin{tcolorbox}[colframe=NavyBlue,
			colback=blue!5!white, 
			left=0mm, 
			right=0mm, 
			top=1mm, 
			bottom=1mm, 
			leftrule=0mm, 
			rightrule=0mm, 
			sharp corners,
		]
		\setlist{leftmargin=*, labelindent=1mm, label={\color{NavyBlue!70!black}$\blacksquare$\!\!}, topsep=0pt}
	}{%
		\end{tcolorbox}
	}
	\DeclareDocumentCommand{\Goal}{m}{%
		\textcolor{NavyBlue}{\bfseries #1}
		\vspace{1mm}\par
	}
	\DeclareDocumentEnvironment{notes}{o}{
		\footnotesize\sffamily\parskip=1.5mm%
		\begin{tcolorbox}[
			colframe=WildStrawberry,colback=red!5!white, 
			left=0mm, 
			right=0mm, 
			top=0mm, 
			bottom=1mm, 
			leftrule=0mm, 
			rightrule=0mm, 
			sharp corners,
			title={\footnotesize\sffamily\bfseries Notes/Misconceptions}
		]
		\setlist{leftmargin=*, labelindent=1mm, label={\color{WildStrawberry!70!black}$\blacksquare$\!\!}, topsep=0pt}
	}{%
		\end{tcolorbox}
	}
	\DeclareDocumentEnvironment{annotation}{o}{
		\footnotesize\sffamily\parskip=1.5mm%
		\MarginParWrap
	}{%
		\endMarginParWrap
	}
	\NewEnviron{MarginParWrap}{
		\marginpar{\BODY}
	}

	% environment for describing lessons
	\newcounter{lessoncounter}
	\DeclareDocumentEnvironment{lesson}{o}{%
		\addtocounter{lessoncounter}{1}
		\setlist{ label={\color{Plum!70!black}$\blacksquare$}, topsep=0pt}
		\newpage
		% increase the margin widths
		\newgeometry{top=.5in,
			headsep=0in, 
			headheight=0in, 
			left=1.2in, 
			bottom=.3in, 
			footskip=0in,
			marginparsep=10pt, 
			marginparwidth=2in,
			right=10pt,
			includeall}
		
		% put a banner on the left of the page
		\begin{tikzpicture}[remember picture,overlay]
		    \draw[line width=25mm,Plum] 
		    ([shift={(0.55\pgflinewidth,-0.05\pgflinewidth)}]current page.north west) 
		    --
		    ([shift={(0.55\pgflinewidth,0.05\pgflinewidth)}]current page.south west) 
			node[anchor=east,pos=0.1,text=white,rotate=90] {\Huge\sffamily Lesson \thelessoncounter};
		\end{tikzpicture}
		
	}{%
		\newpage
	}
	% items in the displayonly environment only show up in "display mode";
	% i.e., when the annotations environment is hidden
	\DeclareDocumentEnvironment{displayonly}{o}{
	}{%
	}
	% environment for describing book "modules"
	\newcounter{modulecounter}
	\def\probset@InModuleEnv{0}
	\newcommand*\probset@cleartooddpage{
		\clearpage
		\ifodd\value{page}
		\else
			\hbox{}
			\newpage
		\fi
	}
	\newcommand\probset@drawModuleBanner[2]{
		\def\bannerpathR{
			([shift={(-0.55\pgflinewidth,-0.05\pgflinewidth)}]current page.north east) 
			--
			([shift={(-0.55\pgflinewidth,0.05\pgflinewidth)}]current page.south east)
		}
		\def\bannerpathL{
			([shift={(0.55\pgflinewidth,-0.05\pgflinewidth)}]current page.north west) 
			--
			([shift={(0.55\pgflinewidth,0.05\pgflinewidth)}]current page.south west)
		}
		\ifstrequal{#2}{reverse}{
			\ifodd\value{page}
				\def\bannerpath{\bannerpathR}
			\else
				\def\bannerpath{\bannerpathL}
			\fi
		}{
			\ifodd\value{page}
				\def\bannerpath{\bannerpathL}
			\else
				\def\bannerpath{\bannerpathR}
			\fi
		}
		\begin{tikzpicture}[remember picture,overlay]
		    \draw[line width=25mm,Turquoise] 
			\bannerpath     
			node[anchor=east,pos=0.1,text=white,rotate=90] {\Huge\sffamily #1};
		\end{tikzpicture}
	}
	\AddToShipoutPictureBG{%
		% if we are in a module page, draw a border
		\IfStrEq{\probset@InModuleEnv}{1}{%
			\ifnum\value{page}=\value{probset@currentModuleStart}
			\else
				% put a banner on the page with no text if we are not the first
				% page in a module
				\probset@drawModuleBanner{\large Module \themodulecounter\, ---\, \themoduletitle}{reverse}
			\fi
		}{}
	}
	\newcounter{probset@currentModuleStart}
	\newcommand{\themoduletitle}{}
	\DeclareDocumentEnvironment{module}{o}{%
		\addtocounter{modulecounter}{1}
		\setlist[itemize]{ label={\color{Turquoise!70!black}$\blacksquare$}, topsep=0pt}
		\probset@cleartooddpage
		% increase the margin widths
		\newgeometry{top=.5in,
			headsep=0in, 
			headheight=0in, 
			right=1.2in, 
			bottom=.5in, 
			footskip=.3in,
			marginparsep=10pt, 
			marginparwidth=1in,
			left=1in,
			%includeall,
			%reversemarginpar,
			twoside=true}
		
		% make sure we know what page this module starts on so
		% we can do something special on the first page
		\setcounter{probset@currentModuleStart}{\value{page}}
		% put a banner on the left of the page
		\probset@drawModuleBanner{Module \themodulecounter}{reverse}

		% renew some document commands to style them appropriately in
		% the module environment
		\RenewDocumentCommand{\Title}{m}{%
			\renewcommand{\themoduletitle}{##1}%
			\begin{center}
				\color{Cerulean}{\sffamily\Large  ##1}
				\addcontentsline{toc}{section}{Module \themodulecounter: ##1}
			\end{center}\par
		}
		\RenewDocumentCommand{\Heading}{m}{%
			{\color{Cerulean}{\hspace{-0.1in}\sffamily\large ##1}}
			\par
		}
		\RenewDocumentEnvironment{definition}{o}{
			\RenewDocumentCommand{\emph}{m}{{\itshape\bfseries\color{Cerulean} ####1}}
			\begin{leftborderbox}[colframe=Cerulean, colback=Cerulean!10]
			{\bfseries\sffamily\color{Cerulean} ##1.}
		}{%
			\end{leftborderbox}
		}
		\RenewDocumentEnvironment{theorem}{o}{
			\RenewDocumentCommand{\emph}{m}{{\itshape\bfseries\color{myorange} ####1}}
			\begin{leftborderbox}[colframe=myorange, colback=myorange!10]
			{\bfseries\sffamily\color{myorange} Theorem.}
		}{%
			\end{leftborderbox}
		}
		\def\probset@InModuleEnv{1}
		
	}{%
		\def\probset@InModuleEnv{0}
		\probset@cleartooddpage
	}
	\DeclareDocumentEnvironment{emphbox}{o}{
		\RenewDocumentCommand{\emph}{m}{{\itshape\bfseries\color{Green} ##1}}
		\begin{leftborderbox}[colframe=Green, colback=Green!10]
		{\bfseries\sffamily\color{Green} #1.}
	}{%
		\end{leftborderbox}
	}
	% custom tcolorbox with colored bar on the left
	\newtcolorbox{leftborderbox}[1][]{
		blanker,
		frame hidden,
		enhanced,
		breakable,
		beforeafter skip=7pt,
		%frame code={
		%	\fill[fill=tcbcol@frame] (frame.south west) -- (interior.south west) -- (interior.north west) -- (frame.north west);
		%	},
		sharp corners,
		borderline west={4pt}{0pt}{tcbcol@frame},
		boxsep=0pt,
		left=8pt,
		right=5pt,
		top=5pt,
		bottom=5pt,
		%boxrule=0pt,
		%leftrule=4pt,
		colframe=myorange,
		colback=myorange!20,
		#1
	}
	\newtcolorbox{thinleftborderbox}[1][]{
		blanker,
		frame hidden,
		enhanced,
		breakable,
		beforeafter skip=7pt,
		%frame code={
		%	\fill[fill=tcbcol@frame] (frame.south west) -- (interior.south west) -- (interior.north west) -- (frame.north west);
		%	},
		sharp corners,
		borderline west={2pt}{0pt}{tcbcol@frame},
		boxsep=0pt,
		left=8pt,
		right=5pt,
		top=5pt,
		bottom=5pt,
		%boxrule=0pt,
		%leftrule=4pt,
		colframe=myorange,
		colback=myorange!20,
		#1
	}
	\DeclareDocumentEnvironment{bookonly}{o}{
	}{%
	}
	\DeclareDocumentEnvironment{example}{o}{
		\renewcommand{\currentbackgroundcolor}{black!2}
		\begin{thinleftborderbox}[colframe=black!50, colback=\currentbackgroundcolor]
		% if we didn't pass in an argument, make the first
		% paragraph have a `\medskip` after it.
		\IfValueTF{#1}{}{
			% redefine \par to be a `\par` followed by a `\medskip`
			% followed by a redefinition of `\par` to what it used to be.
			\let\oldpar\par
			\par\def\par{\oldpar\medskip\let\par\oldpar}
		}{}
		{\bfseries\sffamily Example.}
	}{%
		\end{thinleftborderbox}
	}
	\DeclareDocumentEnvironment{proof}{o}{
		\par{\bfseries Proof.}
	}{%
		\hfill$\blacksquare$
	}
	\DeclareDocumentCommand{\Title}{m}{%
		\begin{center}
			\color{Plum}{\sffamily\Large  #1}
			\addcontentsline{toc}{section}{Lesson \thelessoncounter: #1}
		\end{center}\par
	}
	\DeclareDocumentCommand{\Heading}{m}{%
		{\color{Plum}{\hspace{-0.1in}\sffamily\large #1}}
		\par
	}

% other enumerate environments
\NewDocumentCommand{\prob}{o}{%
	\IfNoValueTF{#1}{%
		\refstepcounter{enumi}%
		\item[\theenumi]%
	}{%
		\refstepcounter{enumi}%
		\item[\theenumi \textsuperscript{#1}]%
	}%
}
\newenvironment{problist}{%
	\begin{enumerate}
	}{%
	\end{enumerate}
}
\newcommand{\Probset@VoidEnvironment}[1]{%
  \expandafter\providecommand\csname env@#1@save@env\endcsname{}%
  \expandafter\providecommand\csname env@#1@process\endcsname{}%
  \@ifundefined{#1}{}{\RenewEnviron{#1}{}}%
}

\newenvironment{exercises}{%
	\DeclareDocumentEnvironment{solution}{o}{
		\nopagebreak
		%\par
			\begin{adjustwidth}{1cm}{}
			\color{cyan}
	}{%
			\end{adjustwidth}
	}
	% XXX hide the solutions for now...
	\Probset@VoidEnvironment{solution}

	% tcolorbox doesn't work with tikz externalize,
	% so we need to disable it around a tcolorbox.
	% since \tikzexternaldisable is locally scoped,
	% create a global version of the command
	\global\let\extdisable\tikzexternaldisable
	\global\let\extenable\tikzexternalenable

	\begin{multicols*}{2}[{%
			\subsection*{Practice Problems}}]\small %
	}{%
	\end{multicols*}%
	\clearpage
}


%%
%% Commands to save definitions for reuse later
%%
% Usage:
% 	\begin{SaveDefinition}[
%  	   		key=unionintersection,          % this is the key used to render the definition later
%			title={Unions \& Intersections}
%		]
%		The \emph{union} of two sets $X$ and $Y$ is $X\cup Y=\ldots$.
% 	\end{SaveDefinition}
\pgfkeys{
	/definitions/all/.initial=
}
\NewEnviron{SaveDefinition}[1][]{%
	% save the arguments in temporary keys for use later
	\pgfkeys{
		/definitions/working/.cd,
		key/.initial,
		title/.initial,
		,#1,% there cannot be a space between the `,` and the `#1`.
		title/.get=\deftitle, % the `.get` commands need to come after `#1`, otherwise the contents of `#1` won't get stored
		key/.get=\defkey,
	}%
	% save the actual definition
	\edef\deflist{\pgfkeysvalueof{/definitions/all}\pgfkeysvalueof{/definitions/working/key},}%
	%
	\edef\compareval{\pgfkeysnovalue}%
	\def\wordtrue{true}
	% we redefine with an \edef so that "title=" and "title={}" will both be recognized as an empty title
	\edef\deftitle{\pgfkeysvalueof{/definitions/working/title}}% 
	%
	% from here on out, we want keys saved to be global
	% we need to use the low-level command here to deal with expansion issues.
	\globaldefs=1\relax%
	\pgfkeyslet{/definitions/all}{\deflist}%
	\pgfkeyslet{/definitions/stored/\defkey/body}{\BODY}%
	\pgfkeyslet{/definitions/stored/\defkey/key}{\defkey}%
	\ifdefequal{\deftitle}{\compareval}{
		% the title is empty
		% XXX This is an annoying hack...I don't know how to get it working another way
		\pgfkeyslet{/definitions/stored/\defkey/title}{\compareval}%
	}{%
		% the title is non-empty
		\pgfkeyslet{/definitions/stored/\defkey/title}{\deftitle}%
	}%
}
\NewDocumentCommand{\SavedDefinitionBody}{m}{%
	\pgfkeysvalueof{/definitions/stored/#1/body}%
}
\NewDocumentCommand{\SavedDefinitionTitle}{m}{%
	\pgfkeysvalueof{/definitions/stored/#1/title}%
}

\NewDocumentCommand{\SavedDefinitionRender}{m}{%
	%\edef\deftitle{\SavedDefinitionTitle{#1}}%
	% XXX I don't know why "\edef\deftitle{\SavedDefinitionTitle{#1}}" doesn't work...
	\edef\deftitle{\pgfkeysvalueof{/definitions/stored/#1/title}}%
	\edef\defbody{\SavedDefinitionBody{#1}}%
	\edef\compareval{\pgfkeysnovalue}%
	\ifdefequal{\deftitle}{\compareval}{%
		% the title is empty, do nothing
		\begin{definition}
			\defbody
		\end{definition}
	}{%
		% the title is non-empty
		\begin{definition}[\deftitle]
			\defbody
		\end{definition}
	}%
}



%%
%% SET UP PRESETS AND DEFAULT ENVIRONMENTS
%%

%\definecolor{myorange}{HTML}{F29B23}
\definecolor{PineGreen}{HTML}{008B72}
\definecolor{LimeGreen}{HTML}{8DC73E}
\definecolor{NavyBlue}{HTML}{006EB8}
\definecolor{BlueGreen}{HTML}{00B3B8}
\definecolor{WildStrawberry}{HTML}{EE2967}
\definecolor{Cerulean}{HTML}{00A2E3}
\definecolor{Green}{HTML}{00A64F}
\definecolor{Blue}{HTML}{2D2F92}
\definecolor{cyan}{HTML}{00AEEF}
\definecolor{Plum}{HTML}{92268F}
\definecolor{Turquoise}{HTML}{00B4CE}
\definecolor{myred}{HTML}{D13409}
\definecolor{mypink}{HTML}{B3094F}
\definecolor{mydark}{HTML}{23112A}
\definecolor{mygreen}{HTML}{34A320}
	\definecolor{defcolor}{rgb}{.05,.4,.15}
	\colorlet{defframecolor}{green!50!black}
	\definecolor{myorange}{HTML}{F29B23}
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

\newcommand{\currentbackgroundcolor}{white}

\setlength{\parindent}{0cm}
\setlength{\parskip}{.17cm}
