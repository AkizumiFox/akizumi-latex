% aaron-hw.cls -- homework.
%   \documentclass[lang=zh, solutions=false]{aaron-hw}
%   \aaronsetup{course=ODE, number=3, due=2026/10/28, id=B12345678}
%   \begin{problem}[optional title] ... \begin{solution} ... \end{solution} \end{problem}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{aaron-hw}[2026/10/21 v0.5 Aaron Lin homework]

\newif\ifaaron@solutions \aaron@solutionstrue
\ExplSyntaxOn
\tl_new:N \l__aaron_size_tl
\tl_set:Nn \l__aaron_size_tl { 11pt }
\keys_define:nn { aaron/hw }
  {
    lang      .code:n = \PassOptionsToPackage { lang = #1 } { aaron-core },
    cjk       .code:n = \PassOptionsToPackage { cjk = #1 } { aaron-core },
    bb        .code:n = \PassOptionsToPackage { bb = #1 } { aaron-core },
    text      .code:n = \PassOptionsToPackage { text = #1 } { aaron-core },
    bib       .code:n = \PassOptionsToPackage { bib = {#1} } { aaron-core },
    paper     .code:n = \PassOptionsToPackage { paper = #1 } { aaron-core },
    layout    .code:n = \PassOptionsToPackage { layout = #1 } { aaron-core },
    solutions .choices:nn = { true, false }
      { \use:c { aaron@solutions \l_keys_choice_tl } },
    solutions .default:n = true,
    10pt      .code:n = \tl_set:Nn \l__aaron_size_tl { 10pt },
    11pt      .code:n = \tl_set:Nn \l__aaron_size_tl { 11pt },
    12pt      .code:n = \tl_set:Nn \l__aaron_size_tl { 12pt },
    unknown   .code:n = \use:x { \exp_not:N \PassOptionsToClass { \l_keys_key_str } { article } },
  }
\ProcessKeyOptions [ aaron/hw ]
% Override from the command line (see aaron-both): \def\aaronsolutions{true|false}
\cs_if_exist:NT \aaronsolutions { \use:c { aaron@solutions \aaronsolutions } }
\use:x { \exp_not:N \LoadClass [ a4paper, \l__aaron_size_tl ] { article } }
\ExplSyntaxOff

\RequirePackage{aaron-core}
\aaron@setgeometry{margin=2.5cm, top=2.3cm, headsep=0.8cm, headheight=15pt}

% ---------- title: "Homework 3", kicker "ODE · Due 2026/10/28" ----------
\title{\ifaaron@zh 作業\else Homework\fi\ifx\aaron@number\@empty\else\ \aaron@number\fi}
\AtBeginDocument{%
  \ifx\aaron@kicker\@empty
    \edef\aaron@kicker{\unexpanded\expandafter{\aaron@course}%
      \ifx\aaron@course\@empty\else\ifx\aaron@due\@empty\else\noexpand\aaronsep\fi\fi
      \ifx\aaron@due\@empty\else\noexpand\aaron@duename\ \unexpanded\expandafter{\aaron@due}\fi}%
  \fi}
\newcommand{\aaron@duename}{\ifaaron@zh 繳交期限\else Due\fi}
\renewcommand{\aaron@headleft}{\aaron@course\ifx\aaron@course\@empty\else\quad\fi\@title}

% ---------- problems ----------
\newcounter{problem}
\ifaaron@zh\crefformat{problem}{#2第~#1~題#3}\else\crefname{problem}{Problem}{Problems}\fi
\newcommand{\problemname}{\ifaaron@zh 第\ \theproblem\ 題\else Problem \theproblem\fi}
\NewDocumentEnvironment{problem}{o}
  {\par\addvspace{1.4em}\Needspace{4\baselineskip}%
   \refstepcounter{problem}%
   \noindent{\sffamily\color{accent}\bfseries\problemname}%
   \IfValueT{#1}{\quad{\sffamily\color{mute}#1}}\par\nobreak\vspace{0.2em}}
  {\par}

% (a), (b), ... inside a problem
\newenvironment{parts}{\begin{enumerate}[label=(\alph*)]}{\end{enumerate}}

% ---------- solutions: thin left rule; hidden with solutions=false ----------
\NewDocumentEnvironment{solution}{+b}
  {\ifaaron@solutions
     \begin{tcolorbox}[aaron/bar={0.8pt}{rule}]%
       {\sffamily\color{mute}\bfseries Solution.}\enspace #1%
     \end{tcolorbox}%
   \fi}
  {}

\endinput
