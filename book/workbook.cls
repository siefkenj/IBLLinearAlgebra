\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{workbook}
              [2020/06/15 v1.0 class for typesetting a workbook]


% extend the article class
\LoadClass{book}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Document class stuff is defined here;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{expl3}


%%
%% LOAD DEPENDENCIES
%%

	% the geometry package will make sure the pdf page gets set to the same size as \paperheight and \paperwidth
	% further, with these settings text will take up 100% of the page
	\RequirePackage[
%showframe,
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




\pagestyle{empty}


%%
%% SET UP PRESETS AND DEFAULT ENVIRONMENTS
%%
\ExplSyntaxOn

% We need some variants of several commands
%\cs_generate_variant:Nn \str_if_in:nnTF {eeTF}  % Doesn't work with current version of tectonic
\cs_generate_variant:Nn \int_set:Nn {Ne}
\cs_generate_variant:Nn \tl_set:Nn {Ne}
\cs_generate_variant:Nn \prop_gput:Nnn {Nne}
\cs_generate_variant:Nn \prop_get:NnN {NeN}
\cs_generate_variant:Nn \prop_gput:Nnn {Neo}
\cs_generate_variant:Nn \prop_gput:Nnn {Nee}
\cs_generate_variant:Nn \prop_gput:Nnn {Nen}
\cs_generate_variant:Nn \prop_gput:Nnn {NeV}
\cs_generate_variant:Nn \prop_item:Nn {NV}
\cs_generate_variant:Nn \prop_item:Nn {Ne}
\cs_generate_variant:Nn \seq_gput_right:Nn {ce}
\cs_generate_variant:Nn \seq_gput_right:Nn {Ne}
\cs_generate_variant:Nn \int_to_arabic:n {v}
\cs_generate_variant:Nn \tl_if_blank:nF {eF}
\cs_generate_variant:Nn \tl_if_empty:nF {eF}
\cs_generate_variant:Nn \tl_if_blank:nTF {eTF}


\cs_new_protected:Nn \_workbook_clear_to_odd_page: {
	\int_if_odd:nF {\value{page}} {
		\hbox{}
		\newpage
	}
}


% Doesn't work with current version of tectonic
%\DeclareDocumentCommand{\JobnameContains}{m}{
%	\str_if_in:eeTF { \str_lower_case:f {\c_sys_jobname_str} }{ \str_lower_case:n { #1 }}{ True }{ False }
%}


\bool_new:N \g_workbook_twosided
\bool_new:N \g_workbook_inline_solutions
\bool_new:N \g_workbook_slides

\keys_define:nn { _workbook_ } {
	twosided .bool_set:N = \g_workbook_twosided,
	twosided .default:n = true,
	twosided .initial:n = true,
	inline~solutions .bool_set:N = \g_workbook_inline_solutions,
	inline~solutions .default:n = true,
	inline~solutions .initial:n = false,
	slides .bool_set:N = \g_workbook_slides,
	slides .default:n = true,
	slides .initial:n = false,
}

\DeclareDocumentCommand\setbookoptions{m} {
	\keys_set:nn { _workbook_ } { #1 }
	\initializebook
}
\DeclareDocumentCommand\initializebook{} {
	% Compute and save the geometry for all of the different layouts. The correct layout
	% is selected in a different function.

	% twoside needs to be set first since some options are computed relative
	% to whether the geometry is onesided or twosided
	\bool_if:nTF \g_workbook_twosided { \geometry{twoside=true} }{ \geometry{twoside=false}	}
	\geometry{
		papersize={8.5in, 11in},
		top=.25in,
		headsep=0in,
		headheight=0in,
		left=.95in,
		bottom=.3in,
		footskip=.2in,
		marginparsep=2pt,
		marginparwidth=2in,
		right=10pt,
		twoside=false,
		includeall
	}
	\savegeometry{default}

	\bool_if:nTF \g_workbook_twosided { \geometry{twoside=true} }{ \geometry{twoside=false}	}
	\geometry{top=.4in,
		headsep=0in,
		headheight=0in,
		left=1.5in,
		bottom=.5in,
		footskip=0in,
		marginparsep=5pt,
		marginparwidth=.8in,
		right=10pt,
		includeall,
		}
	\savegeometry{book}

	\bool_if:nTF \g_workbook_twosided { \geometry{twoside=true} }{ \geometry{twoside=false}	}
	\geometry{top=.25in,
		headsep=0in,
		headheight=0in,
		right=26mm,
		bottom=.3in,
		footskip=.3in,
		marginparsep=10pt,
		marginparwidth=0in,
		left=1in,
		}
	\savegeometry{bannerenv}

	\bool_if:nTF \g_workbook_twosided { \geometry{twoside=true} }{ \geometry{twoside=false}	}
	\geometry{
		left=1.2in,
		bottom=.3in,
		marginparsep=10pt,
		marginparwidth=2in,
		right=10pt,
		}
	\savegeometry{leftbannerenv}

	\bool_if:nTF \g_workbook_twosided { \geometry{twoside=true} }{ \geometry{twoside=false}	}
	\geometry{
		% 4:3 or 16:9
		%papersize={13.3cm, 10cm},
		papersize={17.7cm, 10cm},
		twoside=false,
		noheadfoot,
		marginpar=0pt,
		marginparsep=0pt,
		includeall,
		left=.2cm,
		right=0cm,
		top=.7cm,
		bottom=.7cm,
		%showframe
	}
	\geometry{bottom=\dim_eval:n {\prop_item:Nn \g_workbook_slide_info_prop {margin_bottom}}}
	\geometry{top=\dim_eval:n {\prop_item:Nn \g_workbook_slide_info_prop {margin_top}}}
	\savegeometry{slides}
}



%
% Draw a banner in the margin. This function automatically detects whether
% the document is in one-sided or two-sided mode.
%
% #1 - The text to typeset
% #2 - The color of the banner
% #3 - bool: whether to print the banner on the opposite margin
%
\tl_new:N \l_workbook_banner_path_tl
\cs_new_protected:Nn \_workbook_draw_banner:nnn {
	% this function sets the bool \g_workbook_margin_on_right_bool
	\compute_margin_side

	\bool_set_eq:NN \l_workbook_draw_on_right \g_workbook_margin_on_right_bool
	% If specified by #3, reverse the margin we draw in
	\bool_if:nT {#3} {
		\bool_set_inverse:N \l_workbook_draw_on_right
	}

	\bool_if:nTF {
		\l_workbook_draw_on_right
	} {
		% The banner should be on the right side
		\tl_set:Nn \l_workbook_banner_path_tl {
			([shift={(-0.55\pgflinewidth,-0.05\pgflinewidth)}]current~page.north~east)
			--
			([shift={(-0.55\pgflinewidth,0.05\pgflinewidth)}]current~page.south~east)
		}
	}{
		% The banner should be on the left side
		\tl_set:Nn \l_workbook_banner_path_tl {
			([shift={(0.55\pgflinewidth,-0.05\pgflinewidth)}]current~page.north~west)
			--
			([shift={(0.55\pgflinewidth,0.05\pgflinewidth)}]current~page.south~west)
		}
	}
	% Draw the banner
	\begin{tikzpicture}[remember~picture, overlay]
	    \draw[#2, line~width=25mm]
		\l_workbook_banner_path_tl
		node[anchor=east,pos=0.1,text=white,rotate=90] {#1};
	\end{tikzpicture}
}


%
% Given the name of the environment, this function prints the appropriate border;
% It is meant to be called on each by \AddToShipoutPictureBG
%
\cs_new_protected:Nn \_workbook_draw_environment_border:n {
	\prop_get:NeN \g_workbook_environments_prop {#1/countername} \l_workbook_countername_tl

	\bool_if:nTF {
		\prop_item:Ne \g_workbook_environments_prop {#1/active}
	} {
		\bool_if:nTF {
			\prop_item:Ne \g_workbook_environments_prop {#1/firstpage}
		} {
			\_workbook_draw_environment_border_page:nn {#1}{\c_true_bool}
			% after we render the first page, we are no longer the first page
			\prop_gput:Nen \g_workbook_environments_prop {#1/firstpage} \c_false_bool
		}{
			\_workbook_draw_environment_border_page:nn {#1}{\c_false_bool}
		}
	}{
		% if the environment ever becomes inactive, the next time we render, we'll be rendering the
		% first page
		\prop_gput:Nen \g_workbook_environments_prop {#1/firstpage} \c_true_bool
	}

}
% Helper to draw the border.
%
% #1 - str: the environment name
% #2 - bool: whether this is the first page of the environment or a later page
\cs_new_protected:Nn \_workbook_draw_environment_border_page:nn {
	\prop_get:NeN \g_workbook_environments_prop {#1/banner~color} \l_workbook_banner_color_tl
	\prop_get:NeN \g_workbook_environments_prop {#1/banner~on~left} \l_workbook_banner_on_left_bool

	% \l_workbook_display_title_tl will be set after running this command
	\_workbook_get_environment_display_name:nn {#1}{#2}

	\bool_if:nTF #2 {
		\tl_put_left:Nn \l_workbook_display_title_tl { \Huge\sffamily }
	}{
		\tl_put_left:Nn \l_workbook_display_title_tl { \large\sffamily }
	}

	\_workbook_draw_banner:nnn {
		\l_workbook_display_title_tl
	}{\l_workbook_banner_color_tl}{\l_workbook_banner_on_left_bool}
}

%
% Gets the fully display name of the specified environment and leaves the result
% in \l_workbook_display_title_tl
%
% #1 - env name
% #2 - bool: wheither to add the title suffix or not
\cs_new_protected:Nn \_workbook_get_environment_display_name:nn {
	\prop_get:NeN \g_workbook_environments_prop {#1/display~name} \l_workbook_display_name_tl
	\prop_get:NeN \g_workbook_environments_prop {#1/countername} \l_workbook_countername_tl
	\prop_get:NeN \g_workbook_environments_prop {#1/starred} \l_workbook_starred_bool
	\prop_get:NeN \g_workbook_environments_prop {#1/title} \l_workbook_title_tl

	% This is what will actually be printed in the margin.
	\tl_set:Nn \l_workbook_display_title_tl { \l_workbook_display_name_tl }
	\bool_if:nF \l_workbook_starred_bool {
		% Non-starred environments get a number appended
		\tl_put_right:Nn \l_workbook_display_title_tl { {~} \int_to_arabic:v {\l_workbook_countername_tl} }
	}
	% #2 == False means we are on a later page (v.s. the first page)
	\bool_if:nF #2 {
		\tl_if_blank:eF {\l_workbook_title_tl} {
			% If we have a title, put it at the end
			\tl_put_right:Nn \l_workbook_display_title_tl { ~--~ \l_workbook_title_tl }
		}
	}

%	\l_workbook_display_title_tl
}

%
% Functions to compute which side of the page the margin is on. After
% \compute_margin_side is called, `\g_workbook_margin_on_right_bool` will be set to
% true or false based on whether the margin is on the right.
%
\let\current_page_int\c@page
\bool_new:N \g_workbook_margin_on_right_bool
\def\in_onepage_mode_bool {\dim_compare_p:nNn \oddsidemargin = \evensidemargin }
\def\margin_side_str {\bool_if:nTF \in_onepage_mode_bool {
	right
	}{
		\int_if_even:nTF \current_page_int {
			left
		}{
			right
		}
	}
}
\def\compute_margin_side {
	\bool_if:nTF \in_onepage_mode_bool {
		\bool_set_true:N \g_workbook_margin_on_right_bool
	}{
	\int_if_even:nTF \current_page_int {
		\bool_set_false:N \g_workbook_margin_on_right_bool
	}{
		\bool_set_true:N \g_workbook_margin_on_right_bool
	}
}}


\AddToShipoutPictureBG{
	\seq_map_variable:NNn \g_workbook_environment_names_seq \l_tmpa_str {
		\_workbook_draw_environment_border:n {\l_tmpa_str}
	}
}



% Variables needed for declaring a new environment
%
% Every new environmen declared gets an entry in \g_workbook_environment_names_seq
% Properties of that environment are then stored in \g_workbook_environments_prop as keys-values with the
% key being {\g_workbook_environments_prop}.
\seq_new:N \g_workbook_environment_names_seq
\prop_new:N \g_workbook_environments_prop
\newcommand{\theenvironmentname}{}
\newcommand{\theenvironmentnumber}{0}

%
% Create a new environment with a colored border.
%
\DeclareDocumentCommand\NewColoredEnvironment{m}{
	\keys_define:nn { _workbook_newenv } {
		name .tl_set:N = \l_workbook_newenv_name_tl,
		display~name .tl_set:N = \l_workbook_newenv_display_name_tl,
		banner~color .tl_set:N = \l_workbook_newenv_banner_color_tl,
		open~right .bool_set:N = \l_workbook_newenv_open_right_bool,
		open~right .initial:n = true,
		banner~on~left .bool_set:N = \l_workbook_newenv_banner_on_left_bool,
		banner~on~left .initial:n = false,
		title~color .tl_set:N = \l_workbook_newenv_title_color_tl,
		title~color .initial:n = \c_empty_tl,
		definition~color .tl_set:N = \l_workbook_newenv_definition_color_tl,
		definition~color .initial:n = \c_empty_tl,
		definition~bgcolor .tl_set:N = \l_workbook_newenv_definition_bgcolor_tl,
		definition~bgcolor .initial:n = \c_empty_tl,
		theorem~color .tl_set:N = \l_workbook_newenv_theorem_color_tl,
		theorem~color .initial:n = \c_empty_tl,
		theorem~bgcolor .tl_set:N = \l_workbook_newenv_theorem_bgcolor_tl,
		theorem~bgcolor .initial:n = \c_empty_tl,
		emphbox~color .tl_set:N = \l_workbook_newenv_emphbox_color_tl,
		emphbox~color .initial:n = \c_empty_tl,
		emphbox~bgcolor .tl_set:N = \l_workbook_newenv_emphbox_bgcolor_tl,
		emphbox~bgcolor .initial:n = \c_empty_tl,
	}
	\keys_set:nn {_workbook_newenv} {#1}

	% put all environment information into the props store. We use the `o` variant to expand once
	% since everything in the `newenv` keystore is temporary
	\prop_gput:Neo \g_workbook_environments_prop {\l_workbook_newenv_name_tl/display~name} \l_workbook_newenv_display_name_tl
	\prop_gput:Neo \g_workbook_environments_prop {\l_workbook_newenv_name_tl/banner~color} \l_workbook_newenv_banner_color_tl
	\prop_gput:Neo \g_workbook_environments_prop {\l_workbook_newenv_name_tl/open~right} \l_workbook_newenv_open_right_bool

	% for some reason, boolean options won't expand properly (resulting in the global value getting stored),
	% so we will set them manually with an if statement
	\bool_if:nTF \l_workbook_newenv_open_right_bool {
		\prop_gput:Nen \g_workbook_environments_prop {\l_workbook_newenv_name_tl/open~right} \c_true_bool
	}{
		\prop_gput:Nen \g_workbook_environments_prop {\l_workbook_newenv_name_tl/open~right} \c_false_bool
	}
	\bool_if:nTF \l_workbook_newenv_banner_on_left_bool {
		\prop_gput:Nen \g_workbook_environments_prop {\l_workbook_newenv_name_tl/banner~on~left} \c_true_bool
	}{
		\prop_gput:Nen \g_workbook_environments_prop {\l_workbook_newenv_name_tl/banner~on~left} \c_false_bool
	}

	% Several items get default values. Because we are using temporary global variables, we cannot
	% rely on the `.initial:n = ...` to set relative values (e.g., .initial = \l_workbook_newenv_banner_color_tl)
	% because it would be overridden the next time we declare a new environment. Therefore, we have to
	% set .initial to an empty list and set values in an if statement.
	\tl_if_blank:eTF \l_workbook_newenv_title_color_tl
	{
		\prop_gput:Neo \g_workbook_environments_prop {\l_workbook_newenv_name_tl/title~color} {\l_workbook_newenv_banner_color_tl!20!black}
	}{
		\prop_gput:Neo \g_workbook_environments_prop {\l_workbook_newenv_name_tl/title~color} \l_workbook_newenv_title_color_tl
	}
	\tl_if_blank:eTF \l_workbook_newenv_definition_color_tl
	{
		\prop_gput:Neo \g_workbook_environments_prop {\l_workbook_newenv_name_tl/definition~color} {Plum}
	}{
		\prop_gput:Neo \g_workbook_environments_prop {\l_workbook_newenv_name_tl/definition~color} \l_workbook_newenv_definition_color_tl
	}
	\tl_if_blank:eTF \l_workbook_newenv_definition_bgcolor_tl
	{
		\prop_gput:Nee \g_workbook_environments_prop {\l_workbook_newenv_name_tl/definition~bgcolor} {
			\prop_item:NV \g_workbook_environments_prop {\l_workbook_newenv_name_tl/definition~color}!5!white
		}
	}{
		\prop_gput:Neo \g_workbook_environments_prop {\l_workbook_newenv_name_tl/definition~bgcolor} \l_workbook_newenv_definition_bgcolor_tl
	}
	\tl_if_blank:eTF \l_workbook_newenv_theorem_color_tl
	{
		\prop_gput:Neo \g_workbook_environments_prop {\l_workbook_newenv_name_tl/theorem~color} {Orange}
	}{
		\prop_gput:Neo \g_workbook_environments_prop {\l_workbook_newenv_name_tl/theorem~color} \l_workbook_newenv_theorem_color_tl
	}
	\tl_if_blank:eTF \l_workbook_newenv_theorem_bgcolor_tl
	{
		\prop_gput:Nee \g_workbook_environments_prop {\l_workbook_newenv_name_tl/theorem~bgcolor} {
			\prop_item:NV \g_workbook_environments_prop {\l_workbook_newenv_name_tl/theorem~color}!5!white
		}
	}{
		\prop_gput:Neo \g_workbook_environments_prop {\l_workbook_newenv_name_tl/theorem~bgcolor} \l_workbook_newenv_theorem_bgcolor_tl
	}
	\tl_if_blank:eTF \l_workbook_newenv_emphbox_color_tl
	{
		\prop_gput:Neo \g_workbook_environments_prop {\l_workbook_newenv_name_tl/emphbox~color} {Green}
	}{
		\prop_gput:Neo \g_workbook_environments_prop {\l_workbook_newenv_name_tl/emphbox~color} \l_workbook_newenv_emphbox_color_tl
	}
	\tl_if_blank:eTF \l_workbook_newenv_emphbox_bgcolor_tl
	{
		\prop_gput:Nee \g_workbook_environments_prop {\l_workbook_newenv_name_tl/emphbox~bgcolor} {
			\prop_item:NV \g_workbook_environments_prop {\l_workbook_newenv_name_tl/emphbox~color}!5!white
		}
	}{
		\prop_gput:Neo \g_workbook_environments_prop {\l_workbook_newenv_name_tl/emphbox~bgcolor} \l_workbook_newenv_emphbox_bgcolor_tl
	}

	% we keep a list of all the environment names so we can loop through them in `\AddToShipoutPictureBG`
	\seq_gput_right:NV \g_workbook_environment_names_seq {\l_workbook_newenv_name_tl}

	\_workbook_new_colored_environment:e {\l_workbook_newenv_name_tl}
}
% For internal use. This the expanded (:e) variant of this function is defined
% so that #1 is always the name of the environment.
\cs_new_protected:Nn \_workbook_new_colored_environment:n {
	% These properties must exist on all environments (whether or not the environment is ever used)
	\prop_gput:Nnn \g_workbook_environments_prop {#1/active} \c_false_bool
	\prop_gput:Nnn \g_workbook_environments_prop {#1/firstpage} \c_true_bool
	\prop_gput:Nnn \g_workbook_environments_prop {#1/starred} \c_false_bool
	\prop_gput:Nnn \g_workbook_environments_prop {#1/title} \c_empty_tl

	% A counter for the environment
	\int_new:c {g_workbook_#1_counter_int}
	\prop_gput:Nnn \g_workbook_environments_prop {#1/countername} {g_workbook_#1_counter_int}

	\DeclareDocumentEnvironment{#1}{s}{
		\newpage
		% Set the appropriate geometry
		\bool_if:nTF {\prop_item:Nn \g_workbook_environments_prop {#1/banner~on~left}} {
			\loadgeometry{leftbannerenv}
		}{
			\loadgeometry{bannerenv}
		}

		% If we are in twosided mode *and* we have the `open right` key set, we should
		% ensure that the environment starts on an odd page
		\bool_lazy_and:nnT \g_workbook_twosided { \prop_item:Ne \g_workbook_environments_prop {#1/open~right} } {
			\_workbook_clear_to_odd_page:
		}

		% In order to draw borders for this environment, we need to know whether
		% or not the current page is part of the environment. This is done by checking
		% <envname>/active
		\prop_gput:Nnn \g_workbook_environments_prop {#1/active} \c_true_bool
		\prop_gput:Nnn \g_workbook_environments_prop {#1/firstpage} \c_true_bool

		% update the current env counter
		\int_gincr:c {g_workbook_#1_counter_int}

		\renewcommand{\theenvironmentname}{#1}
		\renewcommand{\theenvironmentnumber}{ \int_to_arabic:v {g_workbook_#1_counter_int} }

		% update other environment properties
		\prop_gput:Nnn \g_workbook_environments_prop {#1/starred} ##1

		% Several macros get declared/overritten when we are in
		% the environment.
		\_workbook_define_colored_environment_macros:n {#1}

		% make sure we can reference the environment number with a \label command
		\def\@currentlabel{\theenvironmentnumber}
	}{
		\newpage
		\prop_gput:Nnn \g_workbook_environments_prop {#1/active} \c_false_bool

		% If we are in twosided mode *and* we have the `open right` key set, we should
		% ensure that the environment starts on an odd page
		\bool_lazy_and:nnT \g_workbook_twosided { \prop_item:Ne \g_workbook_environments_prop {#1/open~right} } {
			\_workbook_clear_to_odd_page:
		}
	}
}
\cs_generate_variant:Nn \_workbook_new_colored_environment:n {e}

\cs_new_protected:Nn \_workbook_define_colored_environment_macros:n {
	\prop_get:NeN \g_workbook_environments_prop {#1/title~color} \l_workbook_title_color_tl


	% Set the itemize style for the environment
	\setlist[itemize]{ label={\color{\l_workbook_title_color_tl!90!black}$\blacksquare$}, topsep=0pt}

	\DeclareDocumentCommand{\Title}{s m}{
		\prop_gput:Nnn \g_workbook_environments_prop {#1/title} {##2}

		\vspace*{.0in}
		\begin{center}
			\color{\l_workbook_title_color_tl}{\sffamily\Large  ##2}
		\end{center}

		% If \Title* is used, don't add the item to the TOC
		\bool_if:nF ##1 {
			% \l_workbook_display_title_tl will be set after running this command
			\_workbook_get_environment_display_name:nn {#1}{\c_false_bool}
			\addcontentsline{toc}{section}{\l_workbook_display_title_tl}
		}
		\par
	}

	\keys_define:nn { _workbook_heading_options } {
		center .bool_set:N = \l_workbook_heading_centered,
		center .default:n = true,
		center .initial:n = false,
		intoc .bool_set:N = \l_workbook_heading_intoc,
		intoc .default:n = true,
		intoc .initial:n = false,
	}
	\DeclareDocumentCommand{\Heading}{O{} m}{
		\keys_set:nn { _workbook_heading_options } { ##1 }
		\vspace{2mm}
		{
			\noindent\color{\l_workbook_title_color_tl}\sffamily\large
			\bool_if:nTF \l_workbook_heading_centered {
				\begin{center}
					##2
				\end{center}
			}{
				\hspace{-0.1in} ##2
			}
		}
		\bool_if:nT \l_workbook_heading_intoc {
			\addcontentsline{toc}{subsection}{##2}
		}
		\nopagebreak
		\par
		\nopagebreak
	}

	% Set up the environments
	\_workbook_define_new_theorem_box:nn {theorem} {
		display~name = Theorem,
		color = \prop_item:Nn \g_workbook_environments_prop {#1/theorem~color},
		bgcolor = \prop_item:Nn \g_workbook_environments_prop {#1/theorem~bgcolor},
		optional~openmark = {(},
		optional~closemark = {)},
	}
	\_workbook_define_new_theorem_box:nn {definition} {
		% For definitions, we just print the term being defined without the word "Definition"
		% in front.
		display~name = {},
		color = \prop_item:Nn \g_workbook_environments_prop {#1/definition~color},
		bgcolor = \prop_item:Nn \g_workbook_environments_prop {#1/definition~bgcolor},
	}
	\_workbook_define_new_theorem_box:nn {emphbox} {
		% For definitions, we just print the term being defined without the word "Definition"
		% in front.
		display~name = {},
		color = \prop_item:Nn \g_workbook_environments_prop {#1/emphbox~color},
		bgcolor = \prop_item:Nn \g_workbook_environments_prop {#1/emphbox~bgcolor},
	}
	\_workbook_define_new_theorem_box:nn {example} {
		display~name = \color{black}Example,
		color = black!50,
		bgcolor = black!2,
		optional~openmark = {(},
		optional~closemark = {)},
		thin = true,
		% We want there to be a medium skip betweent the first and second lines of an example.
		% Therefore, we redefine \par to be a `\par` followed by a `\medskip`
		% followed by a redefinition of `\par` to what it used to be.
		precode = {
			\let\oldpar\par
			\def\par{\oldpar\medskip\let\par\oldpar}
		}
	}
	\_workbook_define_new_theorem_box:nn {objectives} {
		% For definitions, we just print the term being defined without the word "Definition"
		% in front.
		display~name = {},
		color = \prop_item:Nn \g_workbook_environments_prop {#1/emphbox~color},
		bgcolor = \prop_item:Nn \g_workbook_environments_prop {#1/emphbox~bgcolor},
		precode = \addtolength{\parskip}{1mm}
	}

	% Configure the `section` commands in case they are used instead of
	% \Title and \Heading

	\titleformat{\chapter}
	  {\normalfont\sffamily\huge\color{\prop_item:Nn \g_workbook_environments_prop {#1/title~color}}}
	  {\thesection}{1em}{}
	\titleformat{\section}
	  {\normalfont\sffamily\Large\color{\prop_item:Nn \g_workbook_environments_prop {#1/title~color}}}
	  {\thesection}{1em}{}
	\titleformat{\subsection}
	  {\normalfont\sffamily\large\color{\prop_item:Nn \g_workbook_environments_prop {#1/title~color}}}
	  {\thesection}{1em}{}
}

% Create an environment with a `leftborderbox`
%
% #1 - str: environment name
% #2 - keyval: environment properties
\cs_new_protected:Nn \_workbook_define_new_theorem_box:nn {
	\keys_define:nn { _workbook_#1_settings } {
		name .tl_set:N = \l_workbook_name_tl,
		name .initial:n = #1,
		display~name .tl_set:N = \l_workbook_display_name_tl,
		display~name .initial:n = \c_empty_tl,
		color .tl_set:N = \l_workbook_color_tl,
		bgcolor .tl_set:N = \l_workbook_bgcolor_tl,
		optional~openmark .tl_set:N = \l_workbook_openmark_tl,
		optional~openmark .initial:n = \c_empty_tl,
		optional~closemark .tl_set:N = \l_workbook_closemark_tl,
		optional~closemark .initial:n = \c_empty_tl,
		thin .bool_set:N = \l_workbook_thin_variant_bool,
		thin .initial:n = false,
		precode .tl_set:N = \l_workbook_precode_tl,
		precode .initial:n = \c_empty_tl,
	}

	\DeclareDocumentEnvironment{#1}{o}{
		% keys_set sets global variables, but #2 captures the values we want in a "closure".
		% So, set the keys at the start of the environment, instead of before (which would be more efficient).
		\keys_set:nn {_workbook_#1_settings} {#2}

		% Set the itemize style
		\setlist[itemize]{label={\color{\l_workbook_color_tl!90!black}$\blacksquare$}, topsep=0pt}

		% save the current background color so that it can be used in tikz pictures if needed
		\renewcommand{\currentbackgroundcolor}{\l_workbook_bgcolor_tl}

		% Set \emph to be the appropriate color
		\_workbook_renew_emph:n {\l_workbook_color_tl}

		% set up the thin variant
		\tl_set:Nn \l_workbook_left_border_width_tl {4pt}
		\bool_if:nT \l_workbook_thin_variant_bool {
			\tl_set:Nn \l_workbook_left_border_width_tl {2pt}
		}

		% Start the borderbox
		\begin{leftborderbox}[colframe=\l_workbook_color_tl, colback=\l_workbook_bgcolor_tl, borderline~west={\l_workbook_left_border_width_tl}{0pt}{tcbcolframe},]

		% We're going to construct the intro string based on whether or not an optional argument was passed in.
		\tl_set:Nn \l_workbook_display_title_tl { \l_workbook_display_name_tl }
		\tl_if_novalue:nTF {##1} {
			% If there is no optional argument, but there is still a displayname, then
			% we want to add a "." to the end of the display title.
			\tl_if_blank:VF \l_workbook_display_name_tl {
				\tl_put_right:Nn \l_workbook_display_title_tl { . }
			}
		}{
			% If we're here, we have provided the optional argument
			\tl_put_right:Nn \l_workbook_display_title_tl { {~} \l_workbook_openmark_tl ##1 \l_workbook_closemark_tl . }

		}

		{\bfseries\sffamily\color{\l_workbook_color_tl} \l_workbook_display_title_tl} ~

		\l_workbook_precode_tl
	}{
		\end{leftborderbox}
	}
}

% Renew the `\emph` command to highlight in the specified color
\cs_new_protected:Nn \_workbook_renew_emph:n {
	\RenewDocumentCommand{\emph}{m}{{\itshape\bfseries\color{#1} ##1}}
}

% custom tcolorbox with colored bar on the left
\newtcolorbox{leftborderbox}[1][]{
	blanker,
	frame~hidden,
	enhanced,
	breakable,
	beforeafter~skip=7pt,
	sharp~corners,
	%borderline~west={4pt}{0pt}{tcbcolframe},
	boxsep=0pt,
	left=8pt,
	right=5pt,
	top=5pt,
	bottom=5pt,
	colframe=blue,
	colback=blue!20,
	#1
}







%
% Macros for typesetting problems
%

% We cannot directly use \marginpar{...} because it cannot
% handle nested tcolorboxes. So, we wrap it in an environment
\NewDocumentEnvironment{annotation}{+b}{
	\footnotesize\sffamily\parskip=1.5mm%
	\marginpar{#1}
}{
}


% custom tcolorbox for annotations
\newtcolorbox{annotationbox}[1][]{
	colframe=WildStrawberry,
	colback=WildStrawberry!5!white,
	left=0mm,
	right=0mm,
	top=0mm,
	bottom=1mm,
	leftrule=0mm,
	rightrule=0mm,
	sharp~corners,
	#1
}


\DeclareDocumentEnvironment{notes}{o}{
	\tl_set:Nn \l_workbook_box_color_tl {WildStrawberry}
	\footnotesize\sffamily\parskip=1.5mm%
	\begin{annotationbox}[
		colframe=\l_workbook_box_color_tl,
		colback=\l_workbook_box_color_tl!5!white,
		title={\footnotesize\sffamily\bfseries Notes/Misconceptions}
	]
	\setlist{leftmargin=*, labelindent=1mm, label={\color{\l_workbook_box_color_tl!70!black}$\blacksquare$\!\!}, topsep=0pt}
}{
	\end{annotationbox}
}

\DeclareDocumentEnvironment{goals}{o}{
	\tl_set:Nn \l_workbook_box_color_tl {NavyBlue}
	\footnotesize\sffamily\parskip=1.5mm%
	\begin{annotationbox}[
		colframe=\l_workbook_box_color_tl,
		colback=\l_workbook_box_color_tl!5!white,
	]
	\setlist{leftmargin=*, labelindent=1mm, label={\color{\l_workbook_box_color_tl!70!black}$\blacksquare$\!\!}, topsep=0pt}
}{
	\end{annotationbox}
}

\DeclareDocumentCommand{\Goal}{m}{%
	\textcolor{NavyBlue}{\bfseries #1}
	\vspace{1mm}\par
}


\DeclareDocumentEnvironment{proof}{o}{
	\par
	\IfValueTF{#1}{
		{\bfseries Proof (#1).}
	}{
		{\bfseries Proof.}
	}
}{
	\hfill$\blacksquare$
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
		\hspace{.8mm}
		\begin{minipage}[t]{1in}
			\vspace{-2pt}
			{\color{gray}\sffamily\large\thequestion}
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






%
% The definition box for the main text; This is old code. I don't want to touch it...
%
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
\newcommand{\probset@declareoutlinedboxwithlengths}[6]{
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
		skin=enhanced~jigsaw,
		boxrule=1pt,
		fonttitle=\bfseries\sffamily,
		coltitle=#5,
		colbacktitle=white,
		titlerule=0mm,
		colframe=#4,
		coltext=black,
		colback=white,
		top=2pt,
		bottom=2pt,
		bottomtitle=-5pt,
		attach~boxed~title~to~top~left={yshift=-2mm, xshift=4mm},
		boxed~title~style={ boxrule=0pt, colframe=white },
		enlarge~left~by=-1cm-\kvtcb@right@rule,
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








%
% Saveable definitions
%
% \g_workbook_definitions_seq stores a list of all the definitions that have been saved
% \g_workbook_definitions_prop stores the actual content of the definition
\seq_new:N \g_workbook_definitions_seq
\prop_new:N \g_workbook_definitions_prop
\keys_define:nn { _workbook_definitions } {
	key .tl_set:N = \l_workbook_def_key_tl,
	title .tl_set:N = \l_workbook_def_title_tl,
}


% Usage:
% 	\begin{SaveDefinition}[
%  	   		key=unionintersection,          % this is the key used to render the definition later
%			title={Unions \& Intersections}
%		]
%		The \emph{union} of two sets $X$ and $Y$ is $X\cup Y=\ldots$.
% 	\end{SaveDefinition}
\DeclareDocumentEnvironment{SaveDefinition}{r[] +b}{
	% set the \l_workbook_def_key_tl and \l_workbook_def_title_tl macros to have the correct content
	\keys_set:nn { _workbook_definitions } {#1}

	% Save the key in the definitions seq
	\seq_gput_right:NV \g_workbook_definitions_seq {\l_workbook_def_key_tl}

	% Save the definition information
	\prop_gput:Neo \g_workbook_definitions_prop {\l_workbook_def_key_tl/key} \l_workbook_def_key_tl
	\prop_gput:Neo \g_workbook_definitions_prop {\l_workbook_def_key_tl/title} \l_workbook_def_title_tl
	\prop_gput:Nen \g_workbook_definitions_prop {\l_workbook_def_key_tl/body} {#2}
}{}
\NewDocumentCommand{\SavedDefinitionRender}{m}{
	\prop_get:NeN \g_workbook_definitions_prop {#1/title} \l_workbook_title_tl

	\tl_if_blank:eTF {\l_workbook_title_tl} {
		\begin{definition}
	}{
		\begin{definition}[\l_workbook_title_tl]
	}
		\prop_item:Nn \g_workbook_definitions_prop {#1/body}
	\end{definition}
}



%
% Exercises environment
%

\NewDocumentCommand{\prob}{o}{
	\refstepcounter{enumi}
	\IfNoValueTF{#1}{
		\item[\theenumi]
	}{
		\item[\theenumi \textsuperscript{#1}]
	}

	\str_set:Nx \l_workbook_problem_label_str {_workbook_ \theenvironmentname _ \theenvironmentnumber _prob_ \the\value{enumi}}
	% Every problem gets a unique label so that we can refer back to it.
	\label{\l_workbook_problem_label_str}

}
\newenvironment{problist}{
	\begin{enumerate}[leftmargin=*]
}{
	\end{enumerate}
}
\newcommand{\Probset@VoidEnvironment}[1]{%
  \expandafter\providecommand\csname env@#1@save@env\endcsname{}%
  \expandafter\providecommand\csname env@#1@process\endcsname{}%
  \@ifundefined{#1}{}{\RenewEnviron{#1}{}}%
}


% \g_workbook_exercises_seq stores a list of every module/environment we have exercise solutions for.
% \g_workbook_exercises_prop stores in key-val structure all the exercise solutions
\seq_new:N \g_workbook_exercises_seq
\prop_new:N \g_workbook_exercises_prop
\NewDocumentEnvironment{exercises}{}{%
	% create a new list to store the problems in this module/environment
	\seq_new:c {g_workbook_exercises_\theenvironmentname _\theenvironmentnumber _seq}
	% make an easier to refer to name
	\def\l_workbook_current_exercises_seq_c{g_workbook_exercises_\theenvironmentname _\theenvironmentnumber _seq}
	\def\l_workbook_current_problem_number{\the\value{enumi}}

	% Add this batch of exercises to the list
	\tl_set:Ne \l_workbook_exercises_key {\theenvironmentname\theenvironmentnumber}
	\seq_gput_right:NV \g_workbook_exercises_seq {\l_workbook_exercises_key}
	\prop_gput:Nee \g_workbook_exercises_prop {\l_workbook_exercises_key/name} {\theenvironmentname}
	\prop_gput:Nee \g_workbook_exercises_prop {\l_workbook_exercises_key/number} {\theenvironmentnumber}


	% We save the display name for referencing later.
	% after \_workbook_get_environment_display_name:nn is run, \l_workbook_display_title_tl will be set.
	% Passing \c_bool_true as the second argument means we get the short version of the name.
	\_workbook_get_environment_display_name:nn {\theenvironmentname} \c_true_bool
	\prop_gput:Nee \g_workbook_exercises_prop {\l_workbook_exercises_key/display~name} {\l_workbook_display_title_tl}

	% It is more reliable to access the sequence via name, so store the name
	\prop_gput:Nee \g_workbook_exercises_prop {\l_workbook_exercises_key/solutions_seq_c} {	\l_workbook_current_exercises_seq_c }
	\prop_gput:NeV \g_workbook_exercises_prop {\l_workbook_exercises_key/solutions_seq} {
		\use:c \l_workbook_current_exercises_seq_c
	}

	\DeclareDocumentEnvironment{solution}{o +b}{
		% \l_workbook_problem_label_str stores the label used to reference the current problem
		\prop_gput:Nen \g_workbook_exercises_prop {\l_workbook_exercises_key/\l_workbook_current_problem_number/body} {##2}
		\prop_gput:Nee \g_workbook_exercises_prop {\l_workbook_exercises_key/\l_workbook_current_problem_number/reflabel} {\l_workbook_problem_label_str}

		% I am not sure why the line below doesn't work...
		%\seq_gput_right:cV \l_workbook_current_exercises_seq {\the\value{enumi}}
		\seq_gput_right:ce \l_workbook_current_exercises_seq_c {\l_workbook_current_problem_number}

		% Print the solutions inline if so requested
		\bool_if:NT \g_workbook_inline_solutions {
			\nopagebreak
			%\par
			\begin{adjustwidth}{0cm}{}  % indenting solutions seems to take up a lot of space, so don't do it
			\color{cyan}
				##2
			\end{adjustwidth}
		}
	}{
	}
	% tcolorbox doesn't work with tikz externalize,
	% so we need to disable it around a tcolorbox.
	% since \tikzexternaldisable is locally scoped,
	% create a global version of the command
	\global\let\extdisable\tikzexternaldisable
	\global\let\extenable\tikzexternalenable

	\begin{multicols*}{2}[\Heading{Practice~Problems}]
	\small
}{
	\end{multicols*}
	\clearpage
}

\DeclareDocumentCommand{\PrintExerciseSolutions}{}{
	% some testing to see if we can print everything

	% Heading for solutions
	\begin{multicols*}{2}[\Title{Practice~Problem~Solutions}]
	\small


	\seq_map_variable:NNn \g_workbook_exercises_seq \l_workbook_exercises_key {
		\def\l_workbook_heading{Solutions~for~  \prop_item:Ne \g_workbook_exercises_prop {\l_workbook_exercises_key/display~name}}
		\Heading[center, intoc]{\l_workbook_heading}

		\prop_get:NeN \g_workbook_exercises_prop {\l_workbook_exercises_key/name} \l_workbook_current_exercises_name
		\prop_get:NeN \g_workbook_exercises_prop {\l_workbook_exercises_key/number} \l_workbook_current_exercises_number
		% Grab the name of the exercise sequence
		\prop_get:NeN \g_workbook_exercises_prop {\l_workbook_exercises_key/solutions_seq_c} \l_workbook_current_exercises_seq_c
		\seq_set_eq:Nc \l_workbook_current_exercises_seq \l_workbook_current_exercises_seq_c

		\seq_if_empty:NF \l_workbook_current_exercises_seq {
			\begin{enumerate}[leftmargin=*]
				\seq_map_variable:NNn \l_workbook_current_exercises_seq \l_workbook_current_soln_key {
					\item[{
						\hyperref[
							\prop_item:Ne \g_workbook_exercises_prop {\l_workbook_exercises_key/\l_workbook_current_soln_key/reflabel}
						]{\l_workbook_current_soln_key}
					}]
					\prop_item:Ne \g_workbook_exercises_prop {\l_workbook_exercises_key/\l_workbook_current_soln_key/body}
				}
			\end{enumerate}

		}
	}


	\end{multicols*}
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SLIDES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\prop_new:N \g_workbook_slide_info_prop
\dim_new:N \_workbook_current_parskip
\prop_put:Nnn \g_workbook_slide_info_prop {last_page} {0}
\prop_put:Nnn \g_workbook_slide_info_prop {margin_top} {.6cm}
\prop_put:Nnn \g_workbook_slide_info_prop {margin_bottom} {3cm}

\DeclareDocumentCommand{\SlideTitle}{o}{
	\textbf{\sffamily
		Core~Exercise~\int_eval:n {\thequestion + (\IfNoValueTF{#1}{0}{#1})}
	}
}
\DeclareDocumentCommand{\TypesetSlideFooter}{m}{
	\dim_set:Nn \l_tmpa_dim {#1}
	\begin{tikzpicture}[remember~picture, overlay]
		\fill[cyan!50!black] ($(current~page.south~west) + (0,\l_tmpa_dim)$) rectangle (current~page.south~east);
	\end{tikzpicture}
}
\DeclareDocumentCommand{\TypsetSlideHeader}{o m}{
	\dim_set:Nn \l_tmpa_dim {#2}
	\begin{tikzpicture}[remember~picture, overlay]
		\draw[fill=cyan!50!black] ($(current~page.north~west) + (0,-\l_tmpa_dim)$) rectangle (current~page.north~east) 
			node[pos=0, anchor=west, color=white, xshift=1ex, yshift=.5\l_tmpa_dim]{\SlideTitle[#1]};
	\end{tikzpicture}
}

\box_new:N \g_workbook_slide_body_box
\box_new:N \l_workbook_slide_body_tmp_box
\dim_new:N \g_workbook_slide_bodyvailable_height_dim
\dim_new:N \l_workbook_slide_body_request_height_dim
\dim_new:N \l_workbook_slide_body_request_multicol_height_dim
\dim_new:N \l_workbook_slide_minipage_width_dim
\newcounter{question_at_start}
% Typeset to a box. The first arg is the question number to start at
% followed by a font-adjustment command, followed by the material to be typeset
\DeclareDocumentCommand{\TypesetSlideBodyOneCol}{m m +m}{
	\vbox_gset:Nn \g_workbook_slide_body_box {
		\setcounter{question}{#1}
		#2
		\setlength{\fboxrule}{0pt} 
		\fbox{
			\begin{minipage}{\l_workbook_slide_minipage_width_dim}
				#3
			\end{minipage}
		}
	}
}
\DeclareDocumentCommand{\TypesetSlideBodyTwoCol}{m m +m}{
	\vbox_gset:Nn \g_workbook_slide_body_box {
		% We're re-typesetting to see if we can get a better fit. Reset the question counter
		% before this.
		\setcounter{question}{#1}
		% A (possibly blank) font-adjustment command, like \small
		#2
		\setlength{\fboxrule}{0pt} 
		\fbox{
			\begin{minipage}{\l_workbook_slide_minipage_width_dim}
				\begin{multicols}{2}
					#3
				\end{multicols}
			\end{minipage}
		}
	}
}
% Attempt to typeset the slide body as one column or two columns
% choosing the layout that achieves the "best fit" (i.e., needs the least
% amount to scaling).
\dim_new:N \g_workbook_slide_body_request_height
\DeclareDocumentCommand{\TypesetSlideBodyBestFit}{m m m +m}{
	\dim_set:Nn \g_workbook_slide_bodyvailable_height_dim {#1}
	\def\questionStartNumber{#2}
	\def\fontCommand{#3}

	% Try to typeset in one column
	\TypesetSlideBodyOneCol{\questionStartNumber}{\fontCommand}{#4}
	\dim_set:Nn \l_workbook_slide_body_request_height_dim {\box_ht:N \g_workbook_slide_body_box + \box_dp:N \g_workbook_slide_body_box}
	\dim_gset_eq:NN \g_workbook_slide_body_request_height \l_workbook_slide_body_request_height_dim
	
	% If we're too tall, try to typeset as two columns
	\dim_compare:nNnTF {\l_workbook_slide_body_request_height_dim} > {\g_workbook_slide_bodyvailable_height_dim} {
		% scale the original contents so that it fits
		\box_gresize_to_ht_plus_dp:Nn \g_workbook_slide_body_box {\g_workbook_slide_bodyvailable_height_dim}
		\box_gset_eq:NN \l_workbook_slide_body_tmp_box \g_workbook_slide_body_box

		% Try typesetting as two columns
		\TypesetSlideBodyTwoCol{\questionStartNumber}{\fontCommand}{#4}

		% The two-column render might also be too tall; resize if needed
		\dim_set:Nn \l_workbook_slide_body_request_multicol_height_dim {\box_ht:N \g_workbook_slide_body_box + \box_dp:N \g_workbook_slide_body_box}
		\dim_compare:nNnTF {\l_workbook_slide_body_request_multicol_height_dim} > {\g_workbook_slide_bodyvailable_height_dim} {
			\box_gresize_to_ht_plus_dp:Nn \g_workbook_slide_body_box {\g_workbook_slide_bodyvailable_height_dim}
		}{}

		% Pick the better fit and assign it to box a.
		\dim_compare:nNnTF {\l_workbook_slide_body_request_multicol_height_dim} > {\l_workbook_slide_body_request_height_dim} {
			\box_gset_eq:NN \g_workbook_slide_body_box \l_workbook_slide_body_tmp_box
		}{
			\dim_gset_eq:NN \g_workbook_slide_body_request_height \l_workbook_slide_body_request_multicol_height_dim
		}
	}{}
}

% Typeset the slide body. Arguments 1 and 2 are the top and bottom margins
\DeclareDocumentCommand{\TypesetSlideBody}{m m +m}{
	\dim_set:Nn \g_workbook_slide_bodyvailable_height_dim {10cm - (#1) - (#2)}
	\dim_set:Nn \l_workbook_slide_minipage_width_dim {\linewidth - .35cm}
	\box_clear:N \g_workbook_slide_body_box
	\box_clear:N \l_workbook_slide_body_tmp_box
	\setcounter{question_at_start}{\thequestion}

	% Try to typeset in a normal font size
	\TypesetSlideBodyBestFit{\g_workbook_slide_bodyvailable_height_dim}{\thequestion_at_start}{}{#3}
	% If we're too tall by a little bit, we just use the scaled result.
	% Otherwise we will try typesetting with a smaller font.
	% Since the height of a slide is 10cm, we can use 1cm as 10%, etc.
	\dim_compare:nNnTF {\g_workbook_slide_body_request_height - \g_workbook_slide_bodyvailable_height_dim} < {1cm} {}{
		\TypesetSlideBodyBestFit{\g_workbook_slide_bodyvailable_height_dim}{\thequestion_at_start}{\small}{#3}
		\dim_compare:nNnTF {\g_workbook_slide_body_request_height - \g_workbook_slide_bodyvailable_height_dim} < {1cm} {}{
			\TypesetSlideBodyBestFit{\g_workbook_slide_bodyvailable_height_dim}{\thequestion_at_start}{\footnotesize}{#3}
		}
	}
}

% By default the slide environment should do nothing
\DeclareDocumentEnvironment{slide}{o +b}{
	#2
}{}

% The \initSlides command makes the slides environment actually typeset things.
\DeclareDocumentCommand{\initSlides}{}{
	\_workbook_define_new_theorem_box:nn {definition} {
		% For definitions, we just print the term being defined without the word "Definition" in front.
		display~name = {},
		color = LimeGreen!70!black,
		bgcolor = LimeGreen!10!white,
	}
	\_workbook_define_new_theorem_box:nn {theorem} {
		% For definitions, we just print the term being defined without the word "Definition" in front.
		display~name = {Theorem},
		color = Fuchsia,
		bgcolor = Fuchsia!10!white,
	}

	% Slide environment. It's contents are typeset as one or two columns, depending on what fits on the
	% page better. The optional argument is a number 
	\DeclareDocumentEnvironment{slide}{o +b}{
		% We typeset everything in a minipage, so we need to remember the parskip.
		\dim_set_eq:NN \_workbook_current_parskip \parskip

		% The \question macro shouldn't do anything other than increment the question counter.
		% We typeset the question number manually
		\DeclareDocumentCommand{\question}{}{
			\addtocounter{question}{1}
			\def\@currentlabel{\thequestion}
		}

		\clearpage
		% Determine if we need a manual page break based on whether the previous slide was printed
		% on the same page.
		\prop_put:Nnx \g_workbook_slide_info_prop {curr_page} {\thepage}
		\int_compare:nNnTF {\prop_item:Nn \g_workbook_slide_info_prop {curr_page}} = {\prop_item:Nn \g_workbook_slide_info_prop {last_page}} {
			\clearpage
		} {}
		\prop_put:Nnx \g_workbook_slide_info_prop {curr_page} {\thepage}

		% Save the question number from the start and end of the slide so we can
		% compute how many questions are contained in this slide.
		\prop_put:Nnx \g_workbook_slide_info_prop {question_at_start} {\thequestion}
		\TypesetSlideBody{
			\prop_item:Nn \g_workbook_slide_info_prop {margin_top}
		}{
			\prop_item:Nn \g_workbook_slide_info_prop {margin_bottom}
		}{
			##2
		}
		\prop_put:Nnx \g_workbook_slide_info_prop {question_at_end} {\thequestion}
		\prop_put:Nnx \g_workbook_slide_info_prop {num_questions} {
			\int_eval:n {\prop_item:Nn \g_workbook_slide_info_prop {question_at_end} - \prop_item:Nn \g_workbook_slide_info_prop {question_at_start}}
		}

		% Footer
		\TypesetSlideFooter{\prop_item:Nn \g_workbook_slide_info_prop {margin_bottom}}
		% Header
		\TypsetSlideHeader[##1]{\prop_item:Nn \g_workbook_slide_info_prop {margin_top}}
		% Body (typeset last so it appears on top of the header and footer for any overflows.
		% It is centered in case it has been scaled to fit.
		\hfil\box_use:N \g_workbook_slide_body_box\hfil

	}{}


	\DeclareDocumentEnvironment{parts}{o +b}{
		\nopagebreak
		\begin{list}{\formatpartsitem}{
				\usecounter{partsitem}
				\setlength{\leftmargin}{.6cm}
				\setlength{\itemsep}{0cm}
				\setlength{\topsep}{0cm}
			}
			% if we gave the [resume] argument, start counting from where we
			% left off.
			\ifthenelse{ \equal{##1}{resume} }{
				\setcounter{partsitem}{\value{partsitemlast}}
			}{}
		
			% we'd like an sub-enumerate environments
			% to act like they're nested, so advance
			% the level by one.
			\advance\@enumdepth\@ne
			##2
			\setcounter{partsitemlast}{\value{partsitem}}
		\end{list}
	}{
	}
	\RenewDocumentCommand{\section}{sm}{}
	\RenewDocumentCommand{\subsection}{sm}{}
}















%%
%% SET UP PRESETS AND DEFAULT ENVIRONMENTS
%%

\definecolor{myorange}{HTML}{F29B23}
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


% make sure we are compatible with the older version of tcolorbox; tcbcol@frame was renamed to tcbcolframe in newer versions.
\@ifundefined{\string\color@tcbcolframe}{\colorlet{tcbcolframe}{tcbcol@frame}}{}
% The tex install on travis-ci does not have \shellescape for some reason...
\@ifundefined{\string\shellescape}{\gdef\shellescape{0}}{}


\initializebook


\ExplSyntaxOff

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
