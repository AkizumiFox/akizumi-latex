% aaron-exam.cls -- exams and quizzes on top of the exam class.
%   \documentclass[lang=zh, solutions=true]{aaron-exam}
%   \aaronsetup{course=ODE}
%   \title{Midterm} \author{Instructor: Aaron Lin}
%   \begin{questions} \question[10] ... \begin{solution}...\end{solution} \end{questions}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{aaron-exam}[2026/10/21 v0.3 Aaron Lin exam]

\newif\ifaaron@solutions
\ExplSyntaxOn
\tl_new:N \l__aaron_size_tl
\tl_set:Nn \l__aaron_size_tl { 11pt }
\keys_define:nn { aaron/exam }
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
    unknown   .code:n = \use:x { \exp_not:N \PassOptionsToClass { \l_keys_key_str } { exam } },
  }
\ProcessKeyOptions [ aaron/exam ]
% Override from the command line (see aaron-both): \def\aaronsolutions{true|false}
\cs_if_exist:NT \aaronsolutions { \use:c { aaron@solutions \aaronsolutions } }
\use:x { \exp_not:N \LoadClass [ a4paper, \l__aaron_size_tl ] { exam } }
\ExplSyntaxOff

\RequirePackage{aaron-core}
\aaron@setgeometry{margin=2.5cm, headsep=0.8cm, headheight=15pt}
\ifaaron@solutions\printanswers\fi
\addpoints

% ---------- title + name field ----------
\let\aaron@titlepagestyle\relax
\newcommand{\aaron@namefield}{%
  \noindent\ifaaron@zh 姓名\else Name\fi\enspace\makebox[0.32\linewidth]{\hrulefill}%
  \hfill\ifaaron@zh 學號\else ID\fi\enspace\makebox[0.25\linewidth]{\hrulefill}\par\vspace{1.2em}}
\let\aaron@coremaketitle\maketitle
\renewcommand{\maketitle}{\aaron@coremaketitle\ifprintanswers\else\aaron@namefield\fi}
\AtBeginDocument{\ifx\aaron@kicker\@empty\let\aaron@kicker\aaron@course\fi}

% ---------- header / footer ----------
\pagestyle{headandfoot}
\firstpageheader{}{}{}
\runningheader{\sffamily\small\color{mute}\aaron@course}{}{\sffamily\small\color{mute}\@title}
\footer{}{}{\sffamily\scriptsize\color{mute}\thepage\,/\,\numpages}

% ---------- questions and points ----------
\ifaaron@zh
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
  {\begin{tcolorbox}[aaron/bar={0.8pt}{rule}]\solutiontitle\ignorespaces}
  {\unskip\end{tcolorbox}}

\endinput
