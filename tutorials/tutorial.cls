\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{tutorial}[2018/01/13 LaTeX Class for UofT tutorials]
 
\newcommand{\headlinecolor}{\normalcolor}
\LoadClass[12pt]{article}
\RequirePackage{xcolor}
\RequirePackage{tikz}
	\tikzset{>=latex}
	\usetikzlibrary{positioning}
\RequirePackage[many]{tcolorbox}
\RequirePackage[letterpaper, portrait]{geometry}
\RequirePackage{etoolbox}
\RequirePackage{atbegshi}
\RequirePackage{eso-pic}
\RequirePackage{newfile}

\newoutputstream{pagebounds}
\openoutputfile{\jobname.pagebounds}{pagebounds}
 
 

% define the UofT colors
\definecolor{uoftblue}{HTML}{002A5C}
\definecolor{uoftyellow}{HTML}{FFE498}
\definecolor{uoftred}{HTML}{E31837}
\definecolor{uoftteal}{HTML}{008BB0}
\definecolor{uoftblack}{HTML}{271100}

\parskip=.05in
\parindent=0in


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
	parbox=false,
	borderline west={4pt}{0pt}{tcbcol@frame},
	boxsep=0pt,
	left=15pt,
	right=5pt,
	top=5pt,
	bottom=5pt,
	#1
}

\pgfkeys{/tutorial/.is family}
\pgfkeys{/tutorial, 
	name/.initial={Tutorial X},
	author/.initial=\empty,
	course/.initial={MAT XXX},
	date/.initial={},
	term/.initial={},
	title/.initial={},
	part/.initial={}
	} 
% output a string appropriate for the part
\newcommand{\tutorialPartTitle}{\pgfkeys{/tutorial, name} \pgfkeys{/tutorial, part}}
\newcommand{\tutorialCopyright}{% if the author key is empty, the whole copyright line should be omitted
	\setbox0=\hbox{\pgfkeys{/tutorial, author}\unskip}\ifdim\wd0=0pt
	  %
	\else
	  \textcopyright~\pgfkeys{/tutorial, author}%
	\fi%
}

\pagestyle{empty}

% commands to create the header and footer
\newcommand\HeaderBig{\begin{tikzpicture}[remember picture,overlay]
    \tikzset{block/.style={shape=rectangle, node distance=-1pt, minimum width = 10em}}

	\newcommand{\rightpad}{.1in}
	\fill[uoftblue] (current page.north west) rectangle ([yshift=-1in]current page.north east) node (bluetop) {};
	\fill[uoftyellow] ([yshift=-1in]current page.north west) rectangle ([yshift=-1.06in]current page.north east);

	\draw ([yshift=-.4in, xshift=.2in]current page.north) node[block, color=white, anchor=center] (name) {\huge\textbf{\tutorialPartTitle}};
	\node[block, color=white, below=of name] {\large{\pgfkeys{/tutorial, title}}};
	
	% draw items vertically centered on the right margin
	\draw[draw=none] (bluetop.center) -- (current page.north east) node[midway, left, color=white, align=right, xshift=-\rightpad] {
		\Large\textbf{\pgfkeys{/tutorial, course}}\\
		\large{\pgfkeys{/tutorial, term}}\\
		\large{\pgfkeys{/tutorial, date}}
		};
	\draw ([yshift=-.5in, xshift=.15in]current page.north west) node[color=white, anchor=west] {\includegraphics[height=.8in]{uoft-logo-white.pdf}};
\end{tikzpicture}}
\newcommand\Header{\begin{tikzpicture}[remember picture,overlay]
	\newcommand{\rightpad}{.1in}
	\fill[uoftblue] (current page.north west) rectangle ([yshift=-.4in]current page.north east) node (bluetop) {};
	\fill[uoftyellow] ([yshift=-.4in]current page.north west) rectangle ([yshift=-.46in]current page.north east);
	% draw items vertically centered on the right margin
	\draw[draw=none] (bluetop.center) -- (current page.north east) node[midway, left, color=white, align=right] {
		\Large\textbf{\pgfkeys{/tutorial, course}}
		};

	\draw ([yshift=-.2in]current page.north) node[color=white, anchor=center] {
		\Large\textbf{\tutorialPartTitle}};
\end{tikzpicture}}
\newcommand\Footer{\begin{tikzpicture}[remember picture,overlay]
	\newcommand{\rightpad}{.1in}
	\newcommand{\footheight}{.4in}
	\fill[uoftblue] (current page.south west) rectangle ([yshift=\footheight]current page.south east);
	\fill[uoftyellow] ([yshift=\footheight]current page.south west) rectangle ([yshift={\footheight+.06in}]current page.south east);
	\draw ([yshift=.05in, xshift=-\rightpad]current page.south east) node[color=white, anchor=south east] {\textbf{\tutorialCopyright}};
	\draw ([yshift=.05in, xshift=0in]current page.south) node[color=white, anchor=south] {\textbf{Page \thepage}};
\end{tikzpicture}}


% add the custom header and footers to each page
\AddToShipoutPictureBG{\ifnumequal{\value{page}}{1}{\HeaderBig\Footer}{\Header\Footer}}

% make the margin on the first page bigger and the rest starndard size
\newgeometry{left=1in, right=1in, top=1.2in, bottom=.59in}
\gdef\SecondPageGeometry          % <defines the hook>
    {\ifnum 0=\currentgrouplevel   % <only when group level=0>
         \global\let\SecondPageGeometry =\relax  % <clear the hook>
         \expandafter \@gobble     % <gobbles \clearpage in \newgeometry>
	 \newgeometry{left=1in, right=1in, top=.7in, bottom=.59in}
     \else \aftergroup \SecondPageGeometry \fi % <sets the hook again>
     }
\AtBeginShipout {\AtBeginShipoutUpperLeft  % <sets the hook>
    {\SecondPageGeometry }}


% declare the environemets
\newenvironment{tutorial}{%
		\pgfkeys{/tutorial, part={}}%
		\addtostream{pagebounds}{tutorialstart=\thepage}%
	}{%
		\addtostream{pagebounds}{tutorialend=\thepage}\clearpage%
	}
\newenvironment{solutions}{%
		\pgfkeys{/tutorial, part=Solutions}%
		\addtostream{pagebounds}{solutionsstart=\thepage}%
	}{%
		\addtostream{pagebounds}{solutionsend=\thepage}\clearpage%
	}
\newenvironment{instructions}{%
		\pgfkeys{/tutorial, part=Instructions}%
		\addtostream{pagebounds}{instructionsstart=\thepage}%
	}{%
		\addtostream{pagebounds}{instructionsend=\thepage}\clearpage%
	}

%\newenvironment{solutions}{\pgfkeys{/tutorial, part=Solutions}\clearpage}{\addtostream{pagebounds}{\thepage}\clearpage}
%\newenvironment{instructions}{\pgfkeys{/tutorial, part=Instructions}\clearpage}{\addtostream{pagebounds}{\thepage}\clearpage}
\newenvironment{objectives}{\subsection*{Learning Objectives}\begin{leftborderbox}[colframe=uoftyellow, colback=white]}{\end{leftborderbox}}


