% akizumi-book.cls -- theses, long notes, books: chapters, cover page,
% per-chapter contents.
%   \documentclass[lang=zh, bib=refs.bib]{akizumi-book}
%   \akizumisetup{kicker={NTU · Master's Thesis}}
%   \frontmatter \maketitle \tableofcontents
%   \mainmatter \chapter{Introduction} \chaptertoc ...
%   \appendix \chapter{Proofs} ...  \backmatter \printbibliography
% Layout options: twoside, openright, partreset, chaptername=Lecture (see
% akizumi-booklayout.sty).
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{akizumi-book}[2026/10/26 v0.9 Aaron Lin book]

\ExplSyntaxOn
\tl_new:N \l__akizumi_size_tl
\tl_set:Nn \l__akizumi_size_tl { 11pt }
\keys_define:nn { akizumi/book }
  {
    lang    .code:n = \PassOptionsToPackage { lang = #1 } { akizumi-core },
    thmnames .code:n = \PassOptionsToPackage { thmnames = #1 } { akizumi-core },
    cjk     .code:n = \PassOptionsToPackage { cjk = #1 } { akizumi-core },
    bb      .code:n = \PassOptionsToPackage { bb = #1 } { akizumi-core },
    text    .code:n = \PassOptionsToPackage { text = #1 } { akizumi-core },
    bib     .code:n = \PassOptionsToPackage { bib = {#1} } { akizumi-core },
    paper   .code:n = \PassOptionsToPackage { paper = #1 } { akizumi-core },
    layout  .code:n = \PassOptionsToPackage { layout = #1 } { akizumi-core },
    byline  .code:n = \PassOptionsToPackage { byline = #1 } { akizumi-core },
    byline  .default:n = true,
    10pt    .code:n = \tl_set:Nn \l__akizumi_size_tl { 10pt },
    11pt    .code:n = \tl_set:Nn \l__akizumi_size_tl { 11pt },
    12pt    .code:n = \tl_set:Nn \l__akizumi_size_tl { 12pt },
    unknown .code:n = \use:x { \exp_not:N \PassOptionsToClass { \l_keys_key_str } { book } },
  }
% ---- book layout options (implemented in akizumi-booklayout.sty) ----
\tl_new:N \l__akizumi_sides_tl
\tl_set:Nn \l__akizumi_sides_tl { oneside, openany }
\keys_define:nn { akizumi/book }
  {
    oneside     .code:n = \tl_set:Nn \l__akizumi_sides_tl { oneside, openany },
    twoside     .code:n = \tl_set:Nn \l__akizumi_sides_tl { twoside, openany },
    openright   .code:n = \tl_set:Nn \l__akizumi_sides_tl { twoside, openright },
    openany     .code:n = \tl_replace_once:Nnn \l__akizumi_sides_tl { openright } { openany },
    partreset   .bool_gset:N = \g_akizumi_partreset_bool,
    partreset   .default:n = true,
    chaptername .tl_gset:N = \g_akizumi_chaptername_tl,
  }
% ---- end book layout options ----
\ProcessKeyOptions [ akizumi/book ]
\use:x { \exp_not:N \LoadClass [ a4paper, \l__akizumi_sides_tl, \l__akizumi_size_tl ] { book } }
\ExplSyntaxOff

\RequirePackage{akizumi-core}
\akizumi@setgeometry{margin=2.7cm, headsep=0.8cm, headheight=15pt}

% ---------- chapters: muted "Chapter 3" over a large title ----------
\newif\ifakizumi@inappendix
\g@addto@macro\appendix{\global\akizumi@inappendixtrue}
\newcommand{\akizumi@chapterlabel}{%
  \ifakizumi@cjk
    \ifakizumi@inappendix\akizumi@num{appendix}{\thechapter}\else\akizumi@num{chapter}{\thechapter}\fi
  \else \@chapapp~\thechapter\fi}
\titleformat{\chapter}[display]{\sffamily\bfseries\akizumi@headingshape}
  {\color{mute}\large\akizumi@chapterlabel}{0.5em}{\Huge}
\titleformat{name=\chapter,numberless}[display]{\sffamily\bfseries\akizumi@headingshape}
  {}{0pt}{\Huge}
\titlespacing*{\chapter}{0pt}{1.5cm}{1.4cm}
\ifakizumi@cjklabels\crefformat{chapter}{#2\akizumi@num{chapter}{#1}#3}\fi

\akizumi@thmwithin{chapter}

% Running header: chapter left, section right.
\renewcommand{\chaptermark}[1]{\markboth{\ifnum\c@secnumdepth>\m@ne\if@mainmatter\akizumi@headnum{\thechapter}\fi\fi#1}{}}
\renewcommand{\sectionmark}[1]{\markright{\ifnum\c@secnumdepth>\z@\akizumi@headnum{\thesection}\fi#1}}
\renewcommand{\akizumi@headleft}{\leftmark}
\renewcommand{\akizumi@headright}{\rightmark}

% ---------- cover page: the usual title block, a third of the way down ----------
% The cover has no header, so it always shows author and date.
\renewcommand{\maketitle}{%
  \begin{titlepage}
    \vspace*{0.28\textheight}
    {\Large\akizumi@titleblock}
  \end{titlepage}}

% ---------- contents of the current chapter: \chaptertoc ----------
\RequirePackage{etoc}
\newcommand{\chaptertoc}{%
  \begingroup
    \hypersetup{linkcolor=ink}%
    \sffamily\small
    \etocsettocstyle{}{}%
    \etocsetnexttocdepth{subsection}%
    \localtableofcontents
  \endgroup
  \vspace{1em}}

% twoside / openright, \part pages, chapter subtitles, chaptername, cover
% fields, run-in paragraphs, contents number widths, \preface
\RequirePackage{akizumi-booklayout}

\endinput
