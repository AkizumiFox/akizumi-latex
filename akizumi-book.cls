% akizumi-book.cls -- theses, long notes, books: chapters, cover page,
% per-chapter contents.
%   \documentclass[lang=zh, bib=refs.bib]{akizumi-book}
%   \akizumisetup{kicker={NTU · Master's Thesis}}
%   \frontmatter \maketitle \tableofcontents
%   \mainmatter \chapter{Introduction} \chaptertoc ...
%   \appendix \chapter{Proofs} ...  \backmatter \printbibliography
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{akizumi-book}[2026/10/21 v0.6 Aaron Lin book]

\ExplSyntaxOn
\tl_new:N \l__akizumi_size_tl
\tl_set:Nn \l__akizumi_size_tl { 11pt }
\keys_define:nn { akizumi/book }
  {
    lang    .code:n = \PassOptionsToPackage { lang = #1 } { akizumi-core },
    cjk     .code:n = \PassOptionsToPackage { cjk = #1 } { akizumi-core },
    bb      .code:n = \PassOptionsToPackage { bb = #1 } { akizumi-core },
    text    .code:n = \PassOptionsToPackage { text = #1 } { akizumi-core },
    bib     .code:n = \PassOptionsToPackage { bib = {#1} } { akizumi-core },
    paper   .code:n = \PassOptionsToPackage { paper = #1 } { akizumi-core },
    layout  .code:n = \PassOptionsToPackage { layout = #1 } { akizumi-core },
    10pt    .code:n = \tl_set:Nn \l__akizumi_size_tl { 10pt },
    11pt    .code:n = \tl_set:Nn \l__akizumi_size_tl { 11pt },
    12pt    .code:n = \tl_set:Nn \l__akizumi_size_tl { 12pt },
    unknown .code:n = \use:x { \exp_not:N \PassOptionsToClass { \l_keys_key_str } { book } },
  }
\ProcessKeyOptions [ akizumi/book ]
\use:x { \exp_not:N \LoadClass [ a4paper, oneside, openany, \l__akizumi_size_tl ] { book } }
\ExplSyntaxOff

\RequirePackage{akizumi-core}
\akizumi@setgeometry{margin=2.7cm, headsep=0.8cm, headheight=15pt}

% ---------- chapters: muted "Chapter 3" over a large title ----------
\newif\ifakizumi@inappendix
\g@addto@macro\appendix{\global\akizumi@inappendixtrue}
\newcommand{\akizumi@chapterlabel}{%
  \ifakizumi@zh
    \ifakizumi@inappendix 附錄~\thechapter\else 第~\thechapter~章\fi
  \else \@chapapp~\thechapter\fi}
\titleformat{\chapter}[display]{\sffamily\bfseries}
  {\color{mute}\large\akizumi@chapterlabel}{0.5em}{\Huge}
\titleformat{name=\chapter,numberless}[display]{\sffamily\bfseries}
  {}{0pt}{\Huge}
\titlespacing*{\chapter}{0pt}{1.5cm}{1.4cm}
\ifakizumi@zh\crefformat{chapter}{#2第~#1~章#3}\fi

\akizumi@thmwithin{chapter}

% Running header: chapter left, section right.
\renewcommand{\chaptermark}[1]{\markboth{\ifnum\c@secnumdepth>\m@ne\if@mainmatter\thechapter\quad\fi\fi#1}{}}
\renewcommand{\sectionmark}[1]{\markright{\ifnum\c@secnumdepth>\z@\thesection\quad\fi#1}}
\renewcommand{\akizumi@headleft}{\leftmark}
\renewcommand{\akizumi@headright}{\rightmark}

% ---------- cover page: the usual title block, a third of the way down ----------
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

\endinput
