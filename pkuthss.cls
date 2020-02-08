% Peking University dissertation document class
%
% Copyright (c) 2008-2009 solvethis
% Copyright (c) 2010-2018 Casper Ti. Vector
%
% This work may be distributed and/or modified under the conditions of the
% LaTeX Project Public License, either version 1.3 of this license or (at
% your option) any later version.
% The latest version of this license is in
%   https://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX version
% 2005/12/01 or later.
%
% This work has the LPPL maintenance status `maintained'.
% The current maintainer of this work is Casper Ti. Vector.
%
% This work consists of the following files:
%   pkuthss.cls
%   pkuthss-gbk.def
%   pkuthss-utf8.def
%   pkulogo.eps
%   pkuword.eps

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{pkuthss}
	[2018/07/02 v1.8.0 Peking University dissertation document class]

% eg. `\thss@int@boolopt{spacing}{true}' will expand to:
%   \newif\ifthss@opt@spacing \thss@opt@spacingtrue
%   \DeclareOption{spacing}{\thss@opt@spacingtrue}
%   \DeclareOption{nospacing}{\thss@opt@spacingfalse}
\def\thss@int@boolopt#1#2{
	\expandafter\newif\csname ifthss@opt@#1\endcsname
	\@nameuse{thss@opt@#1#2}
	\DeclareOption{#1}{\@nameuse{thss@opt@#1true}}
	\DeclareOption{no#1}{\@nameuse{thss@opt@#1false}}
}
% Process the encoding options.
\newif\ifthss@opt@gbk \thss@opt@gbktrue
\DeclareOption{GBK}{\thss@opt@gbktrue\PassOptionsToClass{GBK}{ctexbook}}
\DeclareOption{UTF8}{\thss@opt@gbkfalse\PassOptionsToClass{UTF8}{ctexbook}}
% Whether to enable `\Uppercase' (works problematically) in heading marks.
\thss@int@boolopt{uppermark}{false}
% Whether to modify fonts according to school regulation.
\thss@int@boolopt{pkufont}{true}
% Whether to modify footnote format according to school regulation.
\thss@int@boolopt{pkufoot}{true}
% Whether to modify spacing according to school regulation.
\thss@int@boolopt{pkuspace}{true}
% Whether to use some common settings for adjusting spacing.
\thss@int@boolopt{spacing}{true}
% Add PDF bookmark for table of contents.
\thss@int@boolopt{pdftoc}{true}
% Whether to enable the `\spacialchap' command.
\thss@int@boolopt{spechap}{true}
% Whether to automatically set up properties for generated PDF from user
% defined document information (author, title, etc.).
\thss@int@boolopt{pdfprop}{true}
% Whether to disable some infractions intended to make the style less ugly.
\thss@int@boolopt{ugly}{false}
% Pass all other options to `ctexbook' document class.
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{ctexbook}}
% Process all class options now.
\ProcessOptions\relax

% Prevent fontspec (loaded by xeCJK) from interfering with newtxmath.
\ifthss@opt@pkufont\PassOptionsToPackage{no-math}{fontspec}\fi
% Work around the `\lvert already defined' error.
% cf. <https://github.com/CTeX-org/ctex-kit/issues/454>.
\ifthss@opt@pkufont\RequirePackage{amsmath}\fi
% pkuthss is based on ctexbook; we use `xiao 4' as default font size.
\LoadClass[zihao = -4]{ctexbook}[2014/03/06]
% ctex 2.x no longer loads ifpdf and ifxetex by itself.
\RequirePackage{ifpdf, ifxetex}
% Provides support for `key = val' grammar.
\RequirePackage{keyval}
% Graphics support.
\RequirePackage{graphicx}[1999/02/16]
% Provides utilities for setting up page layout.
\RequirePackage{geometry}
% fancyhdr provides utilities for setting up headers and footers.
\RequirePackage{fancyhdr}
% Provides `\uline' used in `\maketitle'.
\RequirePackage{ulem}
% `\AtEndOfClass' used to avoid `PDF destination not defined' with setspace.
\AtEndOfClass{\RequirePackage{hyperref}}

\ifthss@opt@gbk
	\input{pkuthss-gbk.def}
	\ifxetex
		% No support for XeLaTeX compilation in non-unicode encoding, i.e. GBK.
		\ClassError{pkuthss}%
			{XeLaTeX compilation is not supported without UTF-8}%
			{%
				XeLaTeX compilation without UTF-8 is very problematic.\MessageBreak
				Therefore please use UTF-8 encoding for the LaTeX code.%
			}
	\fi
\else
	\input{pkuthss-utf8.def}
\fi

\ifthss@opt@pkufont
	% Use Times New Roman / Arial according to school regulation.
	% Option used to prevent newtxtext from manipulating footnote marks.
	\RequirePackage[defaultsups]{newtxtext}
	\RequirePackage[cmintegrals, varg]{newtxmath}
\else
	% Provides `\Box' for originauth.tex if newtx is absent.
	\RequirePackage{latexsym}
\fi

\ifthss@opt@pkufoot
	% Handle the `Unparsed material' issue with latex/dvipdfmx compilation.
	\unless\ifxetex\unless\ifpdf
		\newcommand*\pgfsysdriver{pgfsys-dvipdfm.def}
	\fi\fi
	% Circled text, cf. <https://tex.stackexchange.com/questions/7032/>.
	\RequirePackage{tikz}
	\newcommand*\thss@int@circled[1]{%
		\scalebox{0.8}{\tikz[baseline = (char.base)]{
			\node[
				shape = circle, draw = black, minimum size = 1.25em, inner sep = 0pt
			] (char) {#1};
		}}%
	}
	% Use circled numbers as footnote symbols. Does not affect title page, but
	% footnote is rarely used in dissertation covers ;)
	\renewcommand*{\thefootnote}%
		{\protect\thss@int@circled{\arabic{footnote}}}
	% Provides utility to modify footnote spacing.
	% Option used to make sure it does not render interleaf pages totally blank.
	\RequirePackage[cleardoublepage = current]{scrextend}
	% Set up footnote spacing: whole paragraph indent 2 ccwd, 0.5 ccwd after mark.
	\deffootnote{2\ccwd}{0pt}{\thefootnotemark\hspace{0.5\ccwd}}
\fi

\ifthss@opt@pkuspace
	% lineskip / baselineskip = 20 bp / (12 bp * (6 / 5)).
	\linespread{1.39}\selectfont
	% Provides utilities for setting TOC format; `titles' applied to avoid
	% interfering with LaTeX's own title mechanism.
	\RequirePackage[titles]{tocloft}
	\setlength{\cftbeforechapskip}{6bp plus 1bp}
	\setlength{\cftsecindent}{\ccwd}
	\setlength{\cftsubsecindent}{2\ccwd}
	\setlength{\cftsubsubsecindent}{4\ccwd}
	% `caption' modifies font size and separator of captions.  `subcaption'
	% provides functions similar to `subfigure'/`subfig' but does not clash with
	% `tocloft'; it clashes with `subfigure'/`subfig', but the error message will
	% say they cannot be used simultaneously.
	\RequirePackage{caption, subcaption}
	\DeclareCaptionFont{cfive}{\zihao{5}}
	\DeclareCaptionLabelSeparator{quad}{\quad}
	\captionsetup{font = cfive, labelsep = quad}
\fi

\ifthss@opt@spacing
	% Make spacing nicer in some situations (eg. footnotes and verbatims).
	\RequirePackage{setspace}
	% Remove superfluous spacing between footnotes.
	\setlength{\footnotesep}{0pt}
	% Lists often appear to be too sparse when items are just one or two lines
	% long. Here we cancel the extra vertical spacing between list items.
	% The list margin is adjusted due to Chinese typesetting traditions.
	\RequirePackage{enumitem}
	\setlist{nolistsep, leftmargin = 1.5\parindent}
\fi

\ifthss@opt@spechap
	% This command is used to start a chapter without numbering, and correctly set
	% up the headers and footers in the chapter.
	\newcommand{\specialchap}[1]{%
		\chapter*{#1}\addcontentsline{toc}{chapter}{#1}
		\markboth{#1}{}\phantomsection%
	}
\fi

\AtBeginDocument{
	% Set up spacing for displayed formulae.
	\setlength{\abovedisplayskip}{\belowdisplayshortskip}
	\setlength{\belowdisplayskip}{\abovedisplayskip}

	\ifthss@opt@pdftoc
		% Add PDF bookmark for table of contents.
		\let\thss@tmp@tableofcontents\tableofcontents
		\renewcommand{\tableofcontents}{%
			\thss@int@pdfmark{\contentsname}{contents}
			\thss@tmp@tableofcontents%
		}
	\fi

	\ifthss@opt@pdfprop
		% Automatically generate properties for generated PDF.
		% Use English properties to avoid problems with character encodings.
		\newcommand*{\setpdfproperties}{%
			\hypersetup{
				pdfauthor = {\@eauthor}, pdftitle = {\@etitle},
				pdfsubject = {\euniversity\ \ethesisname}, pdfkeywords = {\@ekeywords}
			}%
		}
		% Set up the properties when generating the title page because the document
		% information should have been all defined before this.
		\let\thss@tmp@maketitle\maketitle
		% NOTE: `\hypersetup' must appear before `\maketitle', otherwise it might
		% not act as expected.
		\renewcommand{\maketitle}{\setpdfproperties\thss@tmp@maketitle}
	\fi
}

% eg. `\thss@int@infoitema{ctitle}' will expand to:
%   \def\ctitle#1{\def\@ctitle{#1}}
%   \define@key{thss@info}{ctitle}{\ctitle{#1}}
\def\thss@int@infoitema#1{
	\@namedef{#1}##1{\@namedef{@#1}{##1}}
	\define@key{thss@info}{#1}{\@nameuse{#1}{##1}}
}
% eg. `\thss@int@infoitemb{cuniversity}' will expand to:
%   \define@key{thss@info}{cuniversity}{\def\cuniversity{#1}}
\def\thss@int@infoitemb#1{
	\define@key{thss@info}{#1}{\@namedef{#1}{##1}}
}
% Set up document information entries.
\thss@int@infoitema{ctitle} 		%论文的中文标题
\thss@int@infoitema{etitle}			%论文的英文标题
\thss@int@infoitema{cauthor}		%作者中文姓名
\thss@int@infoitema{eauthor}		%作者英文姓名
\thss@int@infoitema{studentid}		%学号
\thss@int@infoitema{date}			%日期
\thss@int@infoitema{school}			%学院
\thss@int@infoitema{cmajor}			%专业中文
\thss@int@infoitema{emajor}			%专业英文
\thss@int@infoitema{direction}		%研究方向
\thss@int@infoitema{cmentor}		%导师中文姓名
\thss@int@infoitema{ementor}		%导师英文姓名
\thss@int@infoitema{ckeywords}		%中文关键词
\thss@int@infoitema{ekeywords}		%英文关键词
\thss@int@infoitema{cnumber}		%分类号
\thss@int@infoitema{UnitCode}		%单位代码
\thss@int@infoitema{level}			%论文级别    （硕士/博士）
\thss@int@infoitema{DegreeCategory} %学位类别	 （学术硕士/专业硕士/博士）
\thss@int@infoitema{address}	    %住址邮编
\thss@int@infoitema{telephone}		%电话号码

\thss@int@infoitemb{cuniversity}	%学校中文名	（define in *.def file）
\thss@int@infoitemb{euniversity}	%学校英文名	（define in *.def file）
\thss@int@infoitemb{cthesisname}	%论文种类中文（define in *.def file）
\thss@int@infoitemb{ethesisname}	%论文种类英文（define in *.def file）
\thss@int@infoitemb{cabstractname}	%摘要中文名	（define in *.def file）
\thss@int@infoitemb{eabstractname}	%摘要英文名	（define in *.def file）
% Set up document information using the `key = value' grammar.
\newcommand*{\pkuthssinfo}[1]{\setkeys{thss@info}{#1}}

% Set up page layout.
\geometry{
	a4paper, hmargin = 2.6cm, top = 2.92cm, bottom = 3.03cm,
	headheight = 0.45cm, headsep = 0.59cm, footskip = 1.05cm
}

% Set up chapter/section/... captions.
% The `*skip' values are not supposed to be modified by the `ugly' option:
% the actual style of the school's guide and Word template seem to be different
% from the written specification (when applied verbatim in LaTeX), and here the
% actual style is used.
\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{2}
\ctexset{
	chapter = {
		beforeskip = {0bp}, afterskip = {18bp plus 0.2ex},
		nameformat = {}, titleformat = {}
	}, section =
		{beforeskip = {20bp plus 1ex minus 0.2ex}, afterskip = {5bp plus 0.2ex}},
	subsection =
		{beforeskip = {12bp plus 1ex minus 0.2ex}, afterskip = {5bp plus 0.2ex}},
	subsubsection =
		{beforeskip = {12bp plus 1ex minus 0.2ex}, afterskip = {5bp plus 0.2ex}}
}
\ifthss@opt@ugly
	\ctexset{
		chapter = {format = {\zihao{3}\bfseries\centering}},
		section = {format = {\zihao{4}\bfseries}},
		subsection = {format = {\fontsize{13bp}{15.6bp}\selectfont\bfseries}},
		subsubsection = {format = {\zihao{-4}\bfseries}}
	}
\else
	\ctexset{
		chapter = {format = {\zihao{-2}\bfseries\centering}},
		section = {format = {\zihao{-3}\bfseries}},
		subsection = {format = {\zihao{4}\bfseries}},
		subsubsection = {format = {\bfseries}}
	}
\fi

% `\MakeUppercase' works problematically.
% eg. it converts `\cite{ctex}' into `\cite{CTEX}'.
% This option can disable `\MakeUppercase' in left/right heading marks.
\ifthss@opt@uppermark
	\def\thss@int@setcase#1{#1}
\else
	% Code copied from fancyhdr's `\nouppercase', with the redefinition of
	% `\uppercase' dropped to avoid disrupting CJKutf8.
	% cf. <https://code.google.com/p/ctex-kit/issues/detail?id=147>.
	\def\thss@int@setcase#1{%
		\let\MakeUppercase\relax%
		\expandafter\let\csname MakeUppercase \endcsname\relax%
		#1%
	}
\fi
% The actual page style setup.
\fancypagestyle{plain}{
	\fancyhf{}\renewcommand*{\headrulewidth}{0.75bp}
	\fancyfoot[C]{\zihao{5}\normalfont{\thepage}}
	\if@twoside
		\fancyhead[CE]{\zihao{5}\normalfont{\cuniversity\cthesisname}}
		\fancyhead[CO]{\zihao{5}\normalfont\thss@int@setcase{\leftmark}}
	\else
		\fancyhead[C]{\zihao{5}\normalfont\thss@int@setcase{\leftmark}}
	\fi
}
\pagestyle{plain}

% This places a bookmark pointing to somewhere near the page header;
% Result of simple `\chapter{...} \pdfbookmark{...}' does not look nice,
% because the bookmark will point to somewhere below the chapter mark.
\def\thss@int@pdfmark#1#2{%
	\if@openright\cleardoublepage\else\clearpage\fi
	\pdfbookmark[0]{#1}{#2}%
}

% Usage: \thss@int@fillinblank{(number of lines)}{(line width)}{(contents)}
\def\thss@int@fillinblank#1#2#3{%
	\makebox[0pt][l]{\parbox[t]{#2}{\centering{#3}}}\mbox{}%
	\parbox[t]{#2}{%
		\newcount\thss@tmp@linecount
		\thss@tmp@linecount=#1
		\loop\ifnum\thss@tmp@linecount>0
			% Fill specified space with underline on the bottom line. `\underline'
			% draws line on the baseline (not the bottom line), and this is why
			% `\uline' is used here instead.
			\ifnum\thss@tmp@linecount=1
				\uline{\makebox[#2]{}}
			\else
				\uline{\makebox[#2]{}}\\
			\fi
		\advance\thss@tmp@linecount by -1\relax
		\repeat%
	}%
}

% =================封面========================
\renewcommand{\maketitle}{%
	\thss@int@pdfmark{\titlepagename}{titlepage}
	% Make the title page centered.
	\begin{titlepage}
		{%页眉信息
			
		\fontsize{15}{15} 分\hspace{0.5cm}类\hspace{0.5cm}号：\textrm{\@cnumber}\hspace{5cm}单位代码：\textrm{\@UnitCode}
		
		\fontsize{15}{15} 学\hspace{1.5cm}号：\textrm{\@studentid}\hspace{4.0cm}密\hspace{1.0cm}级：公\hspace{0.4cm}开
		}
		
		\begingroup\centering
		{% 校徽，校名，论文种类
			%校徽
			\begin{center}
				\begin{figure}[h]
					\centerline{\includegraphics[scale=1.0]{./jlu.png}}
				\end{figure}
			\end{center}
			\begin{center}
				\lishu \fontsize{45}{17} 吉\quad 林\quad 大\quad 学\\
				\lishu \fontsize{45}{17}硕\quad 士\quad 学\quad 位\quad 论\quad 文
				\vskip 1.0cm
				\heiti \zihao{2} {\@ctitle}\\
				\rmfamily \zihao{2} {\@etitle} 
			\end{center}
			%\vskip 1.5cm	
		}
		\vfill
		% Information about the author.
		{%
			% Slightly adjust the line skip when using new font size.
			\zihao{3}\linespread{1.75}\selectfont
			\def\thss@tmp@len{0.56\textwidth}
			\begin{tabular}{l@{\extracolsep{0.2em}}c}
				{\bfseries\label@cauthor}		 & \thss@int@fillinblank{1}{\thss@tmp@len}{\fangsong\@cauthor}		  \\%作者姓名
				{\bfseries\label@DegreeCategory} & \thss@int@fillinblank{1}{\thss@tmp@len}{\fangsong\@DegreeCategory} \\%学位类别
				{\bfseries\label@cmajor}		 & \thss@int@fillinblank{1}{\thss@tmp@len}{\fangsong\@cmajor}		  \\%专业
				{\bfseries\label@cmentor}		 & \thss@int@fillinblank{1}{\thss@tmp@len}{\fangsong\@cmentor}		  \\%指导教师
				{\bfseries\label@school}		 & \thss@int@fillinblank{1}{\thss@tmp@len}{\fangsong\@school}		  \\%培养单位
			\end{tabular}%
		}
		\vfill
		% Date.
		{\zihao{-2}\@date}
	\par\endgroup\end{titlepage}%
}
%================投稿声明======================
\newenvironment{mcopyright}{%上定义：留白等待用户内容

}{%下定义
	\noindent
	\\
	论文级别：\@level \\
	学科专业：\@cmajor \\
	论文题目：\@ctitle\\
	\vskip 1.0cm
	\noindent
	作者签名： 　　　　　　　　　指导教师签名： \\
	
	\hspace{6.8cm} 日期：\hspace{2.0cm}年\hspace{1.0cm}月\hspace{1.0cm}日\\
	\vskip 1.0cm
	\vfill\noindent
	作者联系地址（邮编）：\@address\\
	作者联系电话：\@telephone\\
}
% ===============中文摘要======================
\newenvironment{cabstract}{%
	\thss@int@pdfmark{\cabstractname}{cabstract}
	\chapter*{\zihao{4}\cabstractname}\markboth{\cabstractname}{}%
	\centerline{\heiti\zihao{3}\@ctitle}
}{% Keywords at the bottom of the page.
	\vfill\noindent\textbf{\label@ckeywords}{\@ckeywords}%
}
%================英文摘要======================
\newenvironment{eabstract}{%
	\thss@int@pdfmark{\eabstractname}{eabstract}
	\chapter*{\zihao{4}\eabstractname}\markboth{\eabstractname}{}%
	\centerline{\heiti\zihao{3}\@etitle}
}{% Keywords at the bottom of the page.
	\vfill\noindent\textbf{\label@ekeywords}{\@ekeywords}%
}

\endinput
% vim:ft=tex:ts=2:sw=2