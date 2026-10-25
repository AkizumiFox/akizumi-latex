% akizumi-hw.cls -- homework.
%   \documentclass[lang=zh, solutions=false]{akizumi-hw}
%   \akizumisetup{course=ODE, number=3, due=2026/10/28, id=B12345678}
%   \begin{problem}[optional title] ... \begin{solution} ... \end{solution} \end{problem}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{akizumi-hw}[2026/10/25 v0.8 Aaron Lin homework]

\newif\ifakizumi@solutions \akizumi@solutionstrue
\ExplSyntaxOn
\tl_new:N \l__akizumi_size_tl
\tl_set:Nn \l__akizumi_size_tl { 11pt }
\keys_define:nn { akizumi/hw }
  {
    lang      .code:n = \PassOptionsToPackage { lang = #1 } { akizumi-core },
    cjk       .code:n = \PassOptionsToPackage { cjk = #1 } { akizumi-core },
    bb        .code:n = \PassOptionsToPackage { bb = #1 } { akizumi-core },
    text      .code:n = \PassOptionsToPackage { text = #1 } { akizumi-core },
    bib       .code:n = \PassOptionsToPackage { bib = {#1} } { akizumi-core },
    paper     .code:n = \PassOptionsToPackage { paper = #1 } { akizumi-core },
    layout    .code:n = \PassOptionsToPackage { layout = #1 } { akizumi-core },
    byline    .code:n = \PassOptionsToPackage { byline = #1 } { akizumi-core },
    byline    .default:n = true,
    solutions .choices:nn = { true, false }
      { \use:c { akizumi@solutions \l_keys_choice_tl } },
    solutions .default:n = true,
    10pt      .code:n = \tl_set:Nn \l__akizumi_size_tl { 10pt },
    11pt      .code:n = \tl_set:Nn \l__akizumi_size_tl { 11pt },
    12pt      .code:n = \tl_set:Nn \l__akizumi_size_tl { 12pt },
    unknown   .code:n = \use:x { \exp_not:N \PassOptionsToClass { \l_keys_key_str } { article } },
  }
\ProcessKeyOptions [ akizumi/hw ]
% Override from the command line (see akizumi-both): \def\akizumisolutions{true|false}
\cs_if_exist:NT \akizumisolutions { \use:c { akizumi@solutions \akizumisolutions } }
\use:x { \exp_not:N \LoadClass [ a4paper, \l__akizumi_size_tl ] { article } }
\ExplSyntaxOff

\RequirePackage{akizumi-core}
\akizumi@setgeometry{margin=2.5cm, top=2.3cm, headsep=0.8cm, headheight=15pt}

% ---------- title: "Homework 3", kicker "ODE · Due 2026/10/28" ----------
\title{\ifakizumi@zh 作業\else Homework\fi\ifx\akizumi@number\@empty\else\ \akizumi@number\fi}
\AtBeginDocument{%
  \ifx\akizumi@kicker\@empty
    \edef\akizumi@kicker{\unexpanded\expandafter{\akizumi@course}%
      \ifx\akizumi@course\@empty\else\ifx\akizumi@due\@empty\else\noexpand\akizumisep\fi\fi
      \ifx\akizumi@due\@empty\else\noexpand\akizumi@duename\ \unexpanded\expandafter{\akizumi@due}\fi}%
  \fi}
\newcommand{\akizumi@duename}{\ifakizumi@zh 繳交期限\else Due\fi}
\renewcommand{\akizumi@headleft}{\akizumi@course\ifx\akizumi@course\@empty\else\quad\fi\@title}

% ---------- problems ----------
\newcounter{problem}
\ifakizumi@zh\crefformat{problem}{#2第~#1~題#3}\else\crefname{problem}{Problem}{Problems}\fi
\newcommand{\problemname}{\ifakizumi@zh 第\ \theproblem\ 題\else Problem \theproblem\fi}
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
  {\ifakizumi@solutions
     \begin{tcolorbox}[akizumi/bar={0.8pt}{rule}]%
       {\sffamily\color{mute}\bfseries Solution.}\enspace #1%
     \end{tcolorbox}%
   \fi}
  {}

\endinput
