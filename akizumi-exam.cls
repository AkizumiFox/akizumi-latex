% akizumi-exam.cls -- exams and quizzes on top of the exam class.
%   \documentclass[lang=zh, solutions=true]{akizumi-exam}
%   \akizumisetup{course=ODE}
%   \title{Midterm} \author{Instructor: Aaron Lin}
%   \begin{questions} \question[10] ... \begin{solution}...\end{solution} \end{questions}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{akizumi-exam}[2026/10/21 v0.7 Aaron Lin exam]

\newif\ifakizumi@solutions
\ExplSyntaxOn
\tl_new:N \l__akizumi_size_tl
\tl_set:Nn \l__akizumi_size_tl { 11pt }
\keys_define:nn { akizumi/exam }
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
    unknown   .code:n = \use:x { \exp_not:N \PassOptionsToClass { \l_keys_key_str } { exam } },
  }
\ProcessKeyOptions [ akizumi/exam ]
% Override from the command line (see akizumi-both): \def\akizumisolutions{true|false}
\cs_if_exist:NT \akizumisolutions { \use:c { akizumi@solutions \akizumisolutions } }
\use:x { \exp_not:N \LoadClass [ a4paper, \l__akizumi_size_tl ] { exam } }
\ExplSyntaxOff

\RequirePackage{akizumi-core}
\akizumi@setgeometry{margin=2.5cm, headsep=0.8cm, headheight=15pt}
\ifakizumi@solutions\printanswers\fi
\addpoints

% ---------- title + name field ----------
\let\akizumi@titlepagestyle\relax
\newcommand{\akizumi@namefield}{%
  \noindent\ifakizumi@zh 姓名\else Name\fi\enspace\makebox[0.32\linewidth]{\hrulefill}%
  \hfill\ifakizumi@zh 學號\else ID\fi\enspace\makebox[0.25\linewidth]{\hrulefill}\par\vspace{1.2em}}
\let\akizumi@coremaketitle\maketitle
\renewcommand{\maketitle}{\akizumi@coremaketitle\ifprintanswers\else\akizumi@namefield\fi}
\AtBeginDocument{\ifx\akizumi@kicker\@empty\let\akizumi@kicker\akizumi@course\fi}

% ---------- header / footer ----------
\pagestyle{headandfoot}
% byline=false (default): course and "author · date" in the first page's header
\firstpageheader{\ifakizumi@byline\else\sffamily\small\color{mute}\akizumi@course\fi}{}%
  {\ifakizumi@byline\else\sffamily\small\color{mute}\akizumi@byline\fi}
\runningheader{\sffamily\small\color{mute}\akizumi@course}{}{\sffamily\small\color{mute}\@title}
\footer{}{\sffamily\scriptsize\color{mute}\thepage\,/\,\numpages}{}

% ---------- questions and points ----------
\ifakizumi@zh
  \qformat{{\sffamily\color{accent}\bfseries 第\ \thequestion\ 題}\quad{\sffamily\color{mute}\small（\totalpoints\ 分）}\hfill}
  \pointpoints{分}{分}
  \hqword{題號}\hpword{配分}\hsword{得分}\htword{總分}
\else
  \qformat{{\sffamily\color{accent}\bfseries Question \thequestion}\quad{\sffamily\color{mute}\small(\totalpoints\ \points)}\hfill}
  \pointpoints{pt}{pts}
\fi
\pointformat{\textcolor{mute}{\sffamily(\thepoints)}}
\renewcommand{\solutiontitle}{{\sffamily\color{mute}\bfseries Solution.}\enspace}
\renewenvironment{TheSolution}
  {\begin{tcolorbox}[akizumi/bar={0.8pt}{rule}]\solutiontitle\ignorespaces}
  {\unskip\end{tcolorbox}}

\endinput
