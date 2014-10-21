if !has('conceal') || &enc != 'utf-8'
	finish
endif

syntax match   clojureDefine /\v#\(/me=e-1 conceal cchar=λ
syntax keyword clojureDefine fn            conceal cchar=λ

syntax keyword clojureDefine defn  conceal cchar=Ƒ
syntax keyword clojureDefine defn- conceal cchar=ƒ

syntax keyword clojureMacro and conceal cchar=∧
syntax keyword clojureMacro or  conceal cchar=∨
syntax keyword clojureMacro not conceal cchar=¬

syntax keyword clojureFunc <=   conceal cchar=≤
syntax keyword clojureFunc >=   conceal cchar=≥
syntax keyword clojureFunc not= conceal cchar=≠

syntax keyword clojureFunc * conceal cchar=∙
syntax keyword clojureFunc / conceal cchar=÷

syntax keyword clojureFunc int   conceal cchar=ℤ
syntax keyword clojureFunc float conceal cchar=ℝ

syntax keyword clojureConstant nil     conceal cchar=∅
syntax keyword clojureConstant Math/pi conceal cchar=π

syntax keyword clojureRepeat doseq     conceal cchar=∀
syntax keyword clojureMacro  every?    conceal cchar=∀
syntax keyword clojureMacro  some      conceal cchar=∃
syntax keyword clojureMacro  contains? conceal cchar=∈

syntax keyword clojureFunc ->  conceal cchar=→
syntax keyword clojureFunc ->> conceal cchar=↠

" hi! link Conceal Define

setlocal conceallevel=2
