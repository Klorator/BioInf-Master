// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = line(start: (25%,0%), end: (75%,0%))

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): set block(
    fill: luma(230),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.abs
  }
  return block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == str {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == content {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subrefnumbering: "1a",
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => numbering(subrefnumbering, n-super, quartosubfloatcounter.get().first() + 1))
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => {
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          }

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != str {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    block(below: 0pt, new_title_block) +
    old_callout.body.children.at(1))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black, body_background_color: white) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: body_background_color, width: 100%, inset: 8pt, body))
      }
    )
}



#let article(
  title: none,
  subtitle: none,
  authors: none,
  date: none,
  abstract: none,
  abstract-title: none,
  cols: 1,
  lang: "en",
  region: "US",
  font: "libertinus serif",
  fontsize: 11pt,
  title-size: 1.5em,
  subtitle-size: 1.25em,
  heading-family: "libertinus serif",
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 0.65em,
  sectionnumbering: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  doc,
) = {
  set par(justify: true)
  set text(lang: lang,
           region: region,
           font: font,
           size: fontsize)
  set heading(numbering: sectionnumbering)
  if title != none {
    align(center)[#block(inset: 2em)[
      #set par(leading: heading-line-height)
      #if (heading-family != none or heading-weight != "bold" or heading-style != "normal"
           or heading-color != black) {
        set text(font: heading-family, weight: heading-weight, style: heading-style, fill: heading-color)
        text(size: title-size)[#title]
        if subtitle != none {
          parbreak()
          text(size: subtitle-size)[#subtitle]
        }
      } else {
        text(weight: "bold", size: title-size)[#title]
        if subtitle != none {
          parbreak()
          text(weight: "bold", size: subtitle-size)[#subtitle]
        }
      }
    ]]
  }

  if authors != none {
    let count = authors.len()
    let ncols = calc.min(count, 3)
    grid(
      columns: (1fr,) * ncols,
      row-gutter: 1.5em,
      ..authors.map(author =>
          align(center)[
            #author.name \
            #author.affiliation \
            #author.email
          ]
      )
    )
  }

  if date != none {
    align(center)[#block(inset: 1em)[
      #date
    ]]
  }

  if abstract != none {
    block(inset: 2em)[
    #text(weight: "semibold")[#abstract-title] #h(1em) #abstract
    ]
  }

  if toc {
    let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    block(above: 0em, below: 2em)[
    #outline(
      title: toc_title,
      depth: toc_depth,
      indent: toc_indent
    );
    ]
  }

  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
}

#set table(
  inset: 6pt,
  stroke: none
)

#set page(
  paper: "us-letter",
  margin: (x: 1.25in, y: 1.25in),
  numbering: "1",
)

#show: doc => article(
  title: [Assignment 3],
  subtitle: [Statistical inference],
  authors: (
    ( name: [Rasmus Hammar],
      affiliation: [],
      email: [] ),
    ),
  toc_title: [Table of contents],
  toc_depth: 3,
  cols: 1,
  doc,
)

= Part A
<part-a>
== Imports
<imports>
#block[
```python
import pycaret
from pycaret.regression import *
from pycaret.datasets import get_data
```

] <imports>
```{r}
dd <- 5
dd
```

== Data
<data>
```python
dataset_name = "insurance"  # Replace with your desired dataset.
dataset = pycaret.datasets.get_data(dataset_name)
# check the shape of data
dataset.shape
```

#figure([
#table(
  columns: 8,
  align: (auto,auto,auto,auto,auto,auto,auto,auto,),
  table.header([], [age], [sex], [bmi], [children], [smoker], [region], [charges],),
  table.hline(),
  [0], [19], [female], [27.900], [0], [yes], [southwest], [16884.92400],
  [1], [18], [male], [33.770], [1], [no], [southeast], [1725.55230],
  [2], [28], [male], [33.000], [3], [no], [southeast], [4449.46200],
  [3], [33], [male], [22.705], [0], [no], [northwest], [21984.47061],
  [4], [32], [male], [28.880], [0], [no], [northwest], [3866.85520],
)
#block[
```
(1338, 7)
```

]
], caption: figure.caption(
position: top, 
[
Preview of insurance dataset.
]), 
kind: "quarto-float-tbl", 
supplement: "Table", 
)
<tbl-insurance_preview>


#block[
```python
data = dataset.sample(frac=0.9, random_state=786)
data_unseen = dataset.drop(data.index)  # Get all non-selected samples
data.reset_index(drop=True, inplace=True)  # Reset indices of training data
data_unseen.reset_index(drop=True, inplace=True)  # Reset indices in test
print("Data for Modeling: " + str(data.shape))
print("Unseen Data For Predictions: " + str(data_unseen.shape))
```

#block[
```
Data for Modeling: (1204, 7)
Unseen Data For Predictions: (134, 7)
```

]
] <reserve-prediction-data>
== PyCaret environment setup
<pycaret-environment-setup>
```python
# pycaret.regression.setup()
s = setup(data=data, target="charges", train_size=0.7, session_id=123)
print(s)
```

#block[
```
<pycaret.regression.oop.RegressionExperiment object at 0x0000029CD6C81D90>
```

]
#figure([
#table(
  columns: 3,
  align: (auto,auto,auto,),
  table.header([~], [Description], [Value],),
  table.hline(),
  [0], [Session id], [123],
  [1], [Target], [charges],
  [2], [Target type], [Regression],
  [3], [Original data shape], [(1204, 7)],
  [4], [Transformed data shape], [(1204, 10)],
  [5], [Transformed train set shape], [(842, 10)],
  [6], [Transformed test set shape], [(362, 10)],
  [7], [Numeric features], [3],
  [8], [Categorical features], [3],
  [9], [Preprocess], [True],
  [10], [Imputation type], [simple],
  [11], [Numeric imputation], [mean],
  [12], [Categorical imputation], [mode],
  [13], [Maximum one-hot encoding], [25],
  [14], [Encoding method], [None],
  [15], [Fold Generator], [KFold],
  [16], [Fold Number], [10],
  [17], [CPU Jobs], [-1],
  [18], [Use GPU], [False],
  [19], [Log Experiment], [False],
  [20], [Experiment Name], [reg-default-name],
  [21], [USI], [527a],
)
PyCaret setup.

], caption: figure.caption(
separator: "", 
position: top, 
[
]), 
kind: "quarto-float-tbl", 
supplement: "Table", 
)
<tbl-setup>


== Models
<models>
=== Model comparison
<model-comparison>
```python
# 'ridge’= ridge regression
# 'knn' = k-nearest neighbour regression)
model_comparison_RMSE = compare_models(sort="RMSE", include=["ridge", "knn"])
print(model_comparison_RMSE)
```

#block[
```
Ridge(random_state=123)
```

]
#figure([
```
<IPython.core.display.HTML object>
```

#block[
#table(
  columns: 9,
  align: (auto,auto,auto,auto,auto,auto,auto,auto,auto,),
  table.header([~], [Model], [MAE], [MSE], [RMSE], [R2], [RMSLE], [MAPE], [TT (Sec)],),
  table.hline(),
  [ridge], [Ridge Regression], [4203.5881], [35521087.9039], [5935.8918], [0.7487], [0.5780], [0.4377], [1.0060],
  [knn], [K Neighbors Regressor], [8369.3217], [137731520.0000], [11654.1071], [0.0772], [0.8519], [0.9570], [0.0320],
)
]
#block[
```
<IPython.core.display.HTML object>
```

]
], caption: figure.caption(
position: top, 
[
Model comparison for families ridge regression and k-nearest neighbour regression.
]), 
kind: "quarto-float-tbl", 
supplement: "Table", 
)
<tbl-model_comparison>


=== Ridge regression
<ridge-regression>
```python
ridge = create_model("ridge")  # alpha=1 is the default
print(ridge)
```

#block[
```
Ridge(random_state=123)
```

]
#figure([
```
<IPython.core.display.HTML object>
```

Model creation for ridge regression.

#block[
#table(
  columns: 7,
  align: (auto,auto,auto,auto,auto,auto,auto,),
  table.header([~], [MAE], [MSE], [RMSE], [R2], [RMSLE], [MAPE],
    [Fold], [~], [~], [~], [~], [~], [~],),
  table.hline(),
  [0], [4182.1373], [35401077.9684], [5949.8805], [0.7744], [0.7602], [0.4592],
  [1], [3944.9433], [26452404.4226], [5143.1901], [0.8601], [0.4062], [0.4534],
  [2], [4296.4480], [32290104.5761], [5682.4383], [0.7499], [0.4943], [0.4421],
  [3], [4214.2585], [40596824.1914], [6371.5637], [0.6500], [0.7534], [0.4214],
  [4], [4590.5067], [43949373.4255], [6629.4324], [0.7219], [0.5548], [0.3331],
  [5], [3688.4829], [26539533.9107], [5151.6535], [0.8154], [0.4165], [0.3790],
  [6], [4823.6582], [42493624.0333], [6518.7134], [0.7665], [0.5975], [0.4448],
  [7], [3919.1805], [35806862.8576], [5983.8836], [0.6652], [0.6610], [0.4670],
  [8], [4180.0979], [29639387.8983], [5444.2068], [0.8536], [0.4925], [0.5194],
  [9], [4196.1674], [42041685.7556], [6483.9560], [0.6304], [0.6433], [0.4575],
  [Mean], [4203.5881], [35521087.9039], [5935.8918], [0.7487], [0.5780], [0.4377],
  [Std], [309.3727], [6292635.3959], [535.0478], [0.0776], [0.1208], [0.0483],
)
]
#block[
```
<IPython.core.display.HTML object>
```

]
], caption: figure.caption(
separator: "", 
position: top, 
[
]), 
kind: "quarto-float-tbl", 
supplement: "Table", 
)
<tbl-ridge_model>


=== K-neighbours regression
<k-neighbours-regression>
```python
knn = create_model("knn")  # k=5 is the default used here
print(knn)
```

#block[
```
KNeighborsRegressor(n_jobs=-1)
```

]
#figure([
```
<IPython.core.display.HTML object>
```

#block[
#table(
  columns: 7,
  align: (auto,auto,auto,auto,auto,auto,auto,),
  table.header([~], [MAE], [MSE], [RMSE], [R2], [RMSLE], [MAPE],
    [Fold], [~], [~], [~], [~], [~], [~],),
  table.hline(),
  [0], [9552.0674], [178585424.0000], [13363.5859], [-0.1378], [0.8988], [0.9914],
  [1], [9865.5186], [197346112.0000], [14047.9932], [-0.0438], [0.9772], [1.2073],
  [2], [8676.0498], [132782576.0000], [11523.1318], [-0.0283], [0.8971], [1.0728],
  [3], [6846.1108], [90265640.0000], [9500.8232], [0.2219], [0.7623], [0.7492],
  [4], [8637.8623], [143507536.0000], [11979.4629], [0.0918], [0.8503], [0.7107],
  [5], [7336.7485], [116570696.0000], [10796.7910], [0.1892], [0.7169], [0.7892],
  [6], [8991.7021], [158908032.0000], [12605.8730], [0.1267], [0.8161], [0.8060],
  [7], [7859.0146], [101569248.0000], [10078.1572], [0.0502], [0.9236], [1.3133],
  [8], [8535.1631], [147674544.0000], [12152.1416], [0.2707], [0.8448], [0.9717],
  [9], [7392.9800], [110105392.0000], [10493.1113], [0.0321], [0.8316], [0.9584],
  [Mean], [8369.3217], [137731520.0000], [11654.1071], [0.0772], [0.8519], [0.9570],
  [Std], [939.0732], [32557344.7116], [1383.2233], [0.1218], [0.0729], [0.1895],
)
]
#block[
```
<IPython.core.display.HTML object>
```

]
], caption: figure.caption(
position: top, 
[
Model creation for k-nearest neghbour regression.
]), 
kind: "quarto-float-tbl", 
supplement: "Table", 
)
<tbl-k-nearest_model>


== Tuning hyper-parameters
<tuning-hyper-parameters>
#block[
```python
# Example syntax for tuning.
# define tuning grid
ridge_grid = {"alpha": [0, 0.2, 0.4, 0.6, 0.8, 1, 2]}
# tune model with custom grid and metric = MAE (default metric = R^2)
tuned_ridge = tune_model(ridge, custom_grid=ridge_grid, optimize="MAE")
```

]
```python
tuned_ridge = tune_model(ridge)
print(tuned_ridge)
```

#block[
```
Fitting 10 folds for each of 10 candidates, totalling 100 fits
Original model was better than the tuned model, hence it will be returned. NOTE: The display metrics are for the tuned model (not the original one).
Ridge(random_state=123)
```

]
#figure([
```
<IPython.core.display.HTML object>
```

#block[
#table(
  columns: 7,
  align: (auto,auto,auto,auto,auto,auto,auto,),
  table.header([~], [MAE], [MSE], [RMSE], [R2], [RMSLE], [MAPE],
    [Fold], [~], [~], [~], [~], [~], [~],),
  table.hline(),
  [0], [4177.9560], [35375707.3882], [5947.7481], [0.7746], [0.8226], [0.4587],
  [1], [3931.4066], [26359661.7118], [5134.1661], [0.8606], [0.4049], [0.4516],
  [2], [4289.6641], [32298268.2274], [5683.1565], [0.7499], [0.4928], [0.4410],
  [3], [4213.9747], [40698895.1146], [6379.5686], [0.6492], [0.7858], [0.4210],
  [4], [4588.8592], [44034960.9687], [6635.8843], [0.7213], [0.5580], [0.3332],
  [5], [3678.6667], [26506408.5751], [5148.4375], [0.8156], [0.4161], [0.3773],
  [6], [4813.9908], [42444119.3219], [6514.9151], [0.7667], [0.6097], [0.4440],
  [7], [3913.5592], [35866774.7484], [5988.8876], [0.6646], [0.6725], [0.4651],
  [8], [4165.0907], [29514739.7084], [5432.7470], [0.8542], [0.4909], [0.5168],
  [9], [4193.0728], [42077368.3367], [6486.7070], [0.6301], [0.6455], [0.4566],
  [Mean], [4196.6241], [35517690.4101], [5935.2218], [0.7487], [0.5899], [0.4365],
  [Std], [310.4914], [6340413.0563], [539.2891], [0.0781], [0.1369], [0.0478],
)
]
#block[
```
<IPython.core.display.HTML object>
```

]
], caption: figure.caption(
position: top, 
[
Tuning ridge regression model.
]), 
kind: "quarto-float-tbl", 
supplement: "Table", 
)
<tbl-tuning_ridge>


```python
tuned_knn = tune_model(knn)
print(tuned_knn)
```

#block[
```
Fitting 10 folds for each of 10 candidates, totalling 100 fits
KNeighborsRegressor(metric='manhattan', n_jobs=-1, n_neighbors=13,
                    weights='distance')
```

]
#figure([
```
<IPython.core.display.HTML object>
```

#block[
#table(
  columns: 7,
  align: (auto,auto,auto,auto,auto,auto,auto,),
  table.header([~], [MAE], [MSE], [RMSE], [R2], [RMSLE], [MAPE],
    [Fold], [~], [~], [~], [~], [~], [~],),
  table.hline(),
  [0], [7341.2363], [110201200.0230], [10497.6759], [0.2979], [0.7078], [0.7240],
  [1], [8492.7073], [141632154.8776], [11900.9308], [0.2509], [0.7975], [0.9101],
  [2], [7499.6318], [100560336.4708], [10027.9777], [0.2212], [0.7225], [0.7846],
  [3], [6378.3963], [76640954.8645], [8754.4820], [0.3393], [0.6757], [0.6806],
  [4], [7865.6001], [115381513.7215], [10741.5787], [0.2698], [0.7076], [0.6101],
  [5], [6842.1282], [92810094.7430], [9633.7996], [0.3544], [0.6719], [0.7340],
  [6], [7905.8796], [124104279.4995], [11140.2100], [0.3179], [0.6769], [0.6842],
  [7], [6392.8109], [69287664.0805], [8323.9212], [0.3521], [0.7852], [1.0169],
  [8], [8344.1805], [132068728.1548], [11492.1159], [0.3478], [0.7957], [0.9488],
  [9], [6242.3239], [73581314.3652], [8577.9551], [0.3532], [0.6773], [0.7217],
  [Mean], [7330.4895], [103626824.0801], [10109.0647], [0.3104], [0.7218], [0.7815],
  [Std], [789.4799], [24063709.3673], [1197.3449], [0.0459], [0.0492], [0.1257],
)
]
#block[
```
<IPython.core.display.HTML object>
```

]
], caption: figure.caption(
position: top, 
[
Tuning k-nearest neighbour model.
]), 
kind: "quarto-float-tbl", 
supplement: "Table", 
)
<tbl-tuning_k-nearest>


== Predict using test
<predict-using-test>
```python
predict_model(tuned_ridge)
```

#figure([
#table(
  columns: 8,
  align: (auto,auto,auto,auto,auto,auto,auto,auto,),
  table.header([~], [Model], [MAE], [MSE], [RMSE], [R2], [RMSLE], [MAPE],),
  table.hline(),
  [0], [Ridge Regression], [4234.9661], [38106935.9914], [6173.0816], [0.7112], [0.5685], [0.4542],
)
#block[
#table(
  columns: 9,
  align: (auto,auto,auto,auto,auto,auto,auto,auto,auto,),
  table.header([], [age], [sex], [bmi], [children], [smoker], [region], [charges], [prediction\_label],),
  table.hline(),
  [630], [40], [male], [29.900000], [2], [no], [southwest], [6600.360840], [8392.647992],
  [228], [54], [male], [30.020000], [0], [no], [northwest], [24476.478516], [11565.906755],
  [136], [32], [female], [28.930000], [0], [no], [southeast], [3972.924805], [5222.317340],
  [685], [47], [male], [36.080002], [1], [yes], [southeast], [42211.136719], [35437.335282],
  [971], [29], [male], [29.639999], [1], [no], [northeast], [20277.806641], [5859.947146],
  [...], [...], [...], [...], [...], [...], [...], [...], [...],
  [274], [31], [male], [39.490002], [1], [no], [southeast], [3875.734131], [8705.986893],
  [691], [63], [male], [33.660000], [3], [no], [southeast], [15161.534180], [15744.030255],
  [907], [41], [male], [29.639999], [5], [no], [northeast], [9222.402344], [10627.750968],
  [317], [40], [male], [19.799999], [1], [yes], [southeast], [17179.521484], [28051.314835],
  [1149], [41], [female], [33.060001], [2], [no], [northwest], [7749.156250], [10441.804931],
)
]
], caption: figure.caption(
position: top, 
[
Predict testing ridge regression model.
]), 
kind: "quarto-float-tbl", 
supplement: "Table", 
)
<tbl-predict-on-ridge>


```python
predict_model(tuned_knn)
```

#figure([
#table(
  columns: 8,
  align: (auto,auto,auto,auto,auto,auto,auto,auto,),
  table.header([~], [Model], [MAE], [MSE], [RMSE], [R2], [RMSLE], [MAPE],),
  table.hline(),
  [0], [K Neighbors Regressor], [6777.6296], [91135426.9453], [9546.4877], [0.3094], [0.7243], [0.7920],
)
#block[
#table(
  columns: 9,
  align: (auto,auto,auto,auto,auto,auto,auto,auto,auto,),
  table.header([], [age], [sex], [bmi], [children], [smoker], [region], [charges], [prediction\_label],),
  table.hline(),
  [630], [40], [male], [29.900000], [2], [no], [southwest], [6600.360840], [8303.074304],
  [228], [54], [male], [30.020000], [0], [no], [northwest], [24476.478516], [10781.158496],
  [136], [32], [female], [28.930000], [0], [no], [southeast], [3972.924805], [6563.310457],
  [685], [47], [male], [36.080002], [1], [yes], [southeast], [42211.136719], [26222.756365],
  [971], [29], [male], [29.639999], [1], [no], [northeast], [20277.806641], [5045.164830],
  [...], [...], [...], [...], [...], [...], [...], [...], [...],
  [274], [31], [male], [39.490002], [1], [no], [southeast], [3875.734131], [6079.038964],
  [691], [63], [male], [33.660000], [3], [no], [southeast], [15161.534180], [28606.224150],
  [907], [41], [male], [29.639999], [5], [no], [northeast], [9222.402344], [11077.818009],
  [317], [40], [male], [19.799999], [1], [yes], [southeast], [17179.521484], [11315.515123],
  [1149], [41], [female], [33.060001], [2], [no], [northwest], [7749.156250], [11525.464482],
)
]
], caption: figure.caption(
position: top, 
[
Predict testing k-nearest neighbour regression model.
]), 
kind: "quarto-float-tbl", 
supplement: "Table", 
)
<tbl-predict-on-k-nearest>


The ridge regression model has a lower RMSE than the k-nearest neighbour regression model. We proceed with the ridge regression model.

== Plot models
<plot-models>
```python
plot_model(tuned_ridge, plot="error")
```

#quarto_super(
kind: 
"quarto-float-fig"
, 
caption: 
[
]
, 
label: 
<fig-ridge_error>
, 
position: 
bottom
, 
supplement: 
"Figure"
, 
subrefnumbering: 
"1a"
, 
subcapnumbering: 
"(a)"
, 
[
#figure([
```
<IPython.core.display.HTML object>
```

], caption: figure.caption(
position: bottom, 
[
Ridge regression error plot
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-ridge_error-1>


#figure([
#box(image("Assignment_3_Rasmus_Hammar_files/figure-typst/fig-ridge_error-output-2.svg"))
], caption: figure.caption(
separator: "", 
position: bottom, 
[
#block[
]
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-ridge_error-2>


]
)
```python
plot_model(tuned_ridge, plot="feature")
```

#quarto_super(
kind: 
"quarto-float-fig"
, 
caption: 
[
]
, 
label: 
<fig-ridge_feature>
, 
position: 
bottom
, 
supplement: 
"Figure"
, 
subrefnumbering: 
"1a"
, 
subcapnumbering: 
"(a)"
, 
[
#figure([
```
<IPython.core.display.HTML object>
```

], caption: figure.caption(
position: bottom, 
[
Ridge regression important features
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-ridge_feature-1>


#figure([
#box(image("Assignment_3_Rasmus_Hammar_files/figure-typst/fig-ridge_feature-output-2.svg"))
], caption: figure.caption(
separator: "", 
position: bottom, 
[
#block[
]
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-ridge_feature-2>


]
)
== Final model
<final-model>
#block[
```python
final_ridge = finalize_model(tuned_ridge)
```

] <final-model>
== Predict on unseen data
<predict-on-unseen-data>
```python
unseen_predictions = predict_model(final_ridge, data=data_unseen)
unseen_predictions.head()
```

#figure([
#table(
  columns: 8,
  align: (auto,auto,auto,auto,auto,auto,auto,auto,),
  table.header([~], [Model], [MAE], [MSE], [RMSE], [R2], [RMSLE], [MAPE],),
  table.hline(),
  [0], [Ridge Regression], [4464.5295], [44772173.5775], [6691.2012], [0.7068], [0.5842], [0.3461],
)
#block[
#table(
  columns: 9,
  align: (auto,auto,auto,auto,auto,auto,auto,auto,auto,),
  table.header([], [age], [sex], [bmi], [children], [smoker], [region], [charges], [prediction\_label],),
  table.hline(),
  [0], [31], [female], [25.740000], [0], [no], [southeast], [3756.621582], [3728.995735],
  [1], [37], [female], [27.740000], [3], [no], [northwest], [7281.505371], [8163.314403],
  [2], [56], [female], [39.820000], [0], [no], [southeast], [11090.717773], [15074.517559],
  [3], [23], [male], [23.844999], [0], [no], [northeast], [2395.171631], [1846.165868],
  [4], [19], [female], [28.600000], [5], [no], [southwest], [4687.796875], [4379.384856],
)
]
], caption: figure.caption(
position: top, 
[
Predict on unseen data using final ridge regression model.
]), 
kind: "quarto-float-tbl", 
supplement: "Table", 
)
<tbl-predict_unseen>


== Save/load model
<saveload-model>
```python
save_model(final_ridge, "Final Ridge Regression Model")
```

#block[
```
Transformation Pipeline and Model Successfully Saved
```

]
```
(Pipeline(memory=Memory(location=None),
          steps=[('numerical_imputer',
                  TransformerWrapper(include=['age', 'bmi', 'children'],
                                     transformer=SimpleImputer())),
                 ('categorical_imputer',
                  TransformerWrapper(include=['sex', 'smoker', 'region'],
                                     transformer=SimpleImputer(strategy='most_frequent'))),
                 ('ordinal_encoding',
                  TransformerWrapper(include=['sex', 'smoker'],
                                     transfor...
                                                                mapping=[{'col': 'sex',
                                                                          'data_type': dtype('O'),
                                                                          'mapping': female    0
 male      1
 NaN      -1
 dtype: int64},
                                                                         {'col': 'smoker',
                                                                          'data_type': dtype('O'),
                                                                          'mapping': no     0
 yes    1
 NaN   -1
 dtype: int64}]))),
                 ('onehot_encoding',
                  TransformerWrapper(include=['region'],
                                     transformer=OneHotEncoder(cols=['region'],
                                                               handle_missing='return_nan',
                                                               use_cat_names=True))),
                 ('actual_estimator', Ridge(random_state=123))]),
 'Final Ridge Regression Model.pkl')
```

#block[
```python
saved_final_ridge = load_model("Final Ridge Regression Model")
new_prediction = predict_model(saved_final_ridge, data=data_new)
new_prediction.head()
```

] <load-model>
== Questions
<questions>
+ Since the B-fold cross-validation process is conceptually similar to bootstraping, the same method of averaging predictions can be used to estimate the "true" value.

+ The hyper-parameter for ridge regression (alpha) controls how large the coefficients get, i.e.~its purpose is to keep them from getting too large. Alpha is a part of a term that penalizes large coefficients where they are multiplied by alpha, leading to alpha = 0 removing the penalty and larger alpha meaning larger penalty.

+

#block[
#set enum(numbering: "a)", start: 1)
+ Hyper-parameter K controls how many of the closest points to include in the averaging. Larger K leads to a smoother curve but loss of fluctuation.
+ If K = N data points then every time you predict a value it's the average of the entire dataset which is constant.
]

#block[
#set enum(numbering: "1.", start: 4)
+
]

#block[
#set enum(numbering: "a)", start: 1)
+ The tuned ridge regression model has a lower RMSE compared to the tuned k-nearest neighbour regression model when testing using `predict_model`.
+ The mean RMSE for both models is slightly higher when using `predict_model` compared to tuning, which is expected since the model is now being applied to a larger dataset.
]

#block[
#set enum(numbering: "1.", start: 5)
+ B-folds splits the dataset into B parts and uses B-1 for training and repeats this process B times, making it so a larger B leads to larger dataset size with more overlap between training sets. More iterations provides a better estimate of the true value but is more computationally heavy. The most extreme case being B = N where only one row is used for testing. Reducing B to B = 2 would reduce the computational burden but also lead to lower accuracy due to fewer iterations and less overlap between training sets.

+
]

#block[
#set enum(numbering: "a)", start: 1)
+ `compare_models` using default hyper-paramters may indicate that a certain model family is better than another, when after tuning the hyper-parameters the opposite may be true because the defaults are bad for the particular dataset in question.
+ Since `compare_models` is potentially unreliable, it is safer to create and tune models for all model families and then compare the tuned models.
]

#block[
#set enum(numbering: "1.", start: 7)
+
]

#block[
#set enum(numbering: "a)", start: 1)
+ Finalizing the model by retraining it on the full dataset leaves no data for testing/evaluating/tuning hyper-parameters, which may give very different results when applied to a larger dataset.
+ The final model still needs to be tested to verify how good it is, which can be done by applying it to new or reserved data not used in building the model.
]

= Part B
<part-b>
== Data
<data-1>
```python
dataset = get_data("energy")
```

#table(
  columns: 11,
  align: (auto,auto,auto,auto,auto,auto,auto,auto,auto,auto,auto,),
  table.header([], [Relative Compactness], [Surface Area], [Wall Area], [Roof Area], [Overall Height], [Orientation], [Glazing Area], [Glazing Area Distribution], [Heating Load], [Cooling Load],),
  table.hline(),
  [0], [0.98], [514.5], [294.0], [110.25], [7.0], [2], [0.0], [0], [15.55], [21.33],
  [1], [0.98], [514.5], [294.0], [110.25], [7.0], [3], [0.0], [0], [15.55], [21.33],
  [2], [0.98], [514.5], [294.0], [110.25], [7.0], [4], [0.0], [0], [15.55], [21.33],
  [3], [0.98], [514.5], [294.0], [110.25], [7.0], [5], [0.0], [0], [15.55], [21.33],
  [4], [0.90], [563.5], [318.5], [122.50], [7.0], [2], [0.0], [0], [20.84], [28.28],
)
#block[
```python
data=dataset.sample(frac=0.9,random_state=42)
data_unseen=dataset.drop(data.index) # Get all non-selected samples
data.reset_index(drop=True,inplace=True) # Reset indices of training data
data_unseen.reset_index(drop=True,inplace=True) # Reset indices in test
print("Data for Modeling: "+str(data.shape))
print("Unseen Data For Predictions: "+str(data_unseen.shape))
```

#block[
```
Data for Modeling: (691, 10)
Unseen Data For Predictions: (77, 10)
```

]
] <reserve-unseen-data>
== PyCaret environment setup
<pycaret-environment-setup-1>
```python
s = setup(data=data, target="Heating Load", train_size=0.7, session_id=546)
print(s)
```

#table(
  columns: 3,
  align: (auto,auto,auto,),
  table.header([~], [Description], [Value],),
  table.hline(),
  [0], [Session id], [546],
  [1], [Target], [Heating Load],
  [2], [Target type], [Regression],
  [3], [Original data shape], [(691, 10)],
  [4], [Transformed data shape], [(691, 10)],
  [5], [Transformed train set shape], [(483, 10)],
  [6], [Transformed test set shape], [(208, 10)],
  [7], [Numeric features], [9],
  [8], [Preprocess], [True],
  [9], [Imputation type], [simple],
  [10], [Numeric imputation], [mean],
  [11], [Categorical imputation], [mode],
  [12], [Fold Generator], [KFold],
  [13], [Fold Number], [10],
  [14], [CPU Jobs], [-1],
  [15], [Use GPU], [False],
  [16], [Log Experiment], [False],
  [17], [Experiment Name], [reg-default-name],
  [18], [USI], [360b],
)
#block[
```
<pycaret.regression.oop.RegressionExperiment object at 0x0000029D20A66ED0>
```

]
== Create and tune models
<create-and-tune-models>
=== Model comparison
<model-comparison-1>
```python
model_families = ["ridge", "knn"]
model_comparison = compare_models(include=model_families)
print(model_comparison)
```

```
<IPython.core.display.HTML object>
```

#block[
#table(
  columns: 9,
  align: (auto,auto,auto,auto,auto,auto,auto,auto,auto,),
  table.header([~], [Model], [MAE], [MSE], [RMSE], [R2], [RMSLE], [MAPE], [TT (Sec)],),
  table.hline(),
  [ridge], [Ridge Regression], [1.2541], [3.3484], [1.8021], [0.9697], [0.0710], [0.0574], [0.0090],
  [knn], [K Neighbors Regressor], [1.2265], [3.5781], [1.8468], [0.9672], [0.0907], [0.0667], [0.0100],
)
] <compare-models-2>
#block[
```
<IPython.core.display.HTML object>
```

] <compare-models-3>
#block[
```
Ridge(random_state=546)
```

]
Ridge regression is the better model based on RMSE or R^2, but not by much. They are practically equivalent.

=== Model creation
<model-creation>
```python
model_ridge = create_model("ridge")
```

```
<IPython.core.display.HTML object>
```

#block[
#table(
  columns: 7,
  align: (auto,auto,auto,auto,auto,auto,auto,),
  table.header([~], [MAE], [MSE], [RMSE], [R2], [RMSLE], [MAPE],
    [Fold], [~], [~], [~], [~], [~], [~],),
  table.hline(),
  [0], [1.2936], [3.4497], [1.8573], [0.9690], [0.0645], [0.0558],
  [1], [1.6531], [4.9150], [2.2170], [0.9633], [0.0869], [0.0757],
  [2], [1.3912], [4.4604], [2.1120], [0.9599], [0.0788], [0.0615],
  [3], [1.3564], [3.6184], [1.9022], [0.9692], [0.0701], [0.0575],
  [4], [1.3094], [3.7641], [1.9401], [0.9642], [0.0800], [0.0639],
  [5], [1.0340], [2.3996], [1.5491], [0.9766], [0.0711], [0.0514],
  [6], [0.7834], [1.4474], [1.2031], [0.9844], [0.0513], [0.0382],
  [7], [1.2323], [3.3628], [1.8338], [0.9702], [0.0728], [0.0580],
  [8], [1.5482], [4.2715], [2.0668], [0.9592], [0.0732], [0.0614],
  [9], [0.9396], [1.7954], [1.3399], [0.9815], [0.0614], [0.0506],
  [Mean], [1.2541], [3.3484], [1.8021], [0.9697], [0.0710], [0.0574],
  [Std], [0.2547], [1.0828], [0.3175], [0.0083], [0.0096], [0.0093],
)
] <create-ridge-2>
#block[
```
<IPython.core.display.HTML object>
```

] <create-ridge-3>
```python
model_knn = create_model("knn")
```

```
<IPython.core.display.HTML object>
```

#block[
#table(
  columns: 7,
  align: (auto,auto,auto,auto,auto,auto,auto,),
  table.header([~], [MAE], [MSE], [RMSE], [R2], [RMSLE], [MAPE],
    [Fold], [~], [~], [~], [~], [~], [~],),
  table.hline(),
  [0], [1.0773], [2.3247], [1.5247], [0.9791], [0.0736], [0.0541],
  [1], [1.1329], [3.5512], [1.8845], [0.9735], [0.1101], [0.0724],
  [2], [1.6314], [6.7111], [2.5906], [0.9396], [0.1147], [0.0824],
  [3], [1.2328], [2.9370], [1.7138], [0.9750], [0.0774], [0.0609],
  [4], [1.4497], [5.7166], [2.3909], [0.9457], [0.1112], [0.0831],
  [5], [1.3157], [3.9977], [1.9994], [0.9610], [0.0957], [0.0709],
  [6], [0.7938], [1.2503], [1.1182], [0.9866], [0.0592], [0.0436],
  [7], [1.2533], [2.7683], [1.6638], [0.9755], [0.1118], [0.0845],
  [8], [1.3945], [4.0950], [2.0236], [0.9609], [0.0849], [0.0630],
  [9], [0.9841], [2.4295], [1.5587], [0.9750], [0.0684], [0.0517],
  [Mean], [1.2265], [3.5781], [1.8468], [0.9672], [0.0907], [0.0667],
  [Std], [0.2297], [1.5559], [0.4092], [0.0143], [0.0196], [0.0136],
)
] <create-knn-2>
#block[
```
<IPython.core.display.HTML object>
```

] <create-knn-3>
=== Model tuning
<model-tuning>
```python
ridge_grid = {"alpha": [0, 0.1, 0.3, 0.5, 0.7, 1, 2, 4, 8]}
tuned_ridge = tune_model(model_ridge, custom_grid=ridge_grid, optimize="RMSE")
print(tuned_ridge)
```

```
<IPython.core.display.HTML object>
```

#block[
#table(
  columns: 7,
  align: (auto,auto,auto,auto,auto,auto,auto,),
  table.header([~], [MAE], [MSE], [RMSE], [R2], [RMSLE], [MAPE],
    [Fold], [~], [~], [~], [~], [~], [~],),
  table.hline(),
  [0], [1.2548], [3.3560], [1.8319], [0.9698], [0.0648], [0.0546],
  [1], [1.6302], [4.8830], [2.2098], [0.9636], [0.0873], [0.0751],
  [2], [1.3721], [4.3018], [2.0741], [0.9613], [0.0782], [0.0611],
  [3], [1.3332], [3.5701], [1.8895], [0.9696], [0.0700], [0.0565],
  [4], [1.2918], [3.8023], [1.9500], [0.9639], [0.0807], [0.0635],
  [5], [0.9961], [2.2937], [1.5145], [0.9776], [0.0706], [0.0501],
  [6], [0.7871], [1.4783], [1.2159], [0.9841], [0.0525], [0.0389],
  [7], [1.2598], [3.4196], [1.8492], [0.9697], [0.0732], [0.0588],
  [8], [1.5612], [4.2607], [2.0641], [0.9593], [0.0745], [0.0626],
  [9], [0.9260], [1.7325], [1.3163], [0.9821], [0.0615], [0.0507],
  [Mean], [1.2412], [3.3098], [1.7915], [0.9701], [0.0713], [0.0572],
  [Std], [0.2546], [1.0753], [0.3167], [0.0082], [0.0095], [0.0092],
)
] <tune-ridge-2>
#block[
```
<IPython.core.display.HTML object>
```

] <tune-ridge-3>
#block[
```
Fitting 10 folds for each of 9 candidates, totalling 90 fits
Ridge(alpha=0.1, random_state=546)
```

]
```python
knn_grid = {"n_neighbors": [3, 5, 7, 9, 11]}
tuned_knn = tune_model(model_knn, custom_grid=knn_grid, optimize="RMSE")
print(tuned_knn)
```

```
<IPython.core.display.HTML object>
```

#block[
#table(
  columns: 7,
  align: (auto,auto,auto,auto,auto,auto,auto,),
  table.header([~], [MAE], [MSE], [RMSE], [R2], [RMSLE], [MAPE],
    [Fold], [~], [~], [~], [~], [~], [~],),
  table.hline(),
  [0], [1.0639], [2.8043], [1.6746], [0.9748], [0.0654], [0.0480],
  [1], [1.1116], [2.9410], [1.7149], [0.9781], [0.0976], [0.0680],
  [2], [1.5633], [6.7091], [2.5902], [0.9396], [0.1106], [0.0756],
  [3], [1.0408], [2.2337], [1.4946], [0.9810], [0.0674], [0.0496],
  [4], [1.1908], [3.8724], [1.9678], [0.9632], [0.0943], [0.0680],
  [5], [1.2438], [4.1718], [2.0425], [0.9593], [0.0971], [0.0671],
  [6], [0.7396], [1.1682], [1.0808], [0.9874], [0.0566], [0.0394],
  [7], [1.1194], [3.0738], [1.7532], [0.9728], [0.0973], [0.0699],
  [8], [1.4215], [4.1232], [2.0306], [0.9606], [0.0824], [0.0609],
  [9], [0.7894], [1.6484], [1.2839], [0.9830], [0.0549], [0.0404],
  [Mean], [1.1284], [3.2746], [1.7633], [0.9700], [0.0824], [0.0587],
  [Std], [0.2389], [1.4905], [0.4066], [0.0136], [0.0188], [0.0125],
)
] <tune-knn-2>
#block[
```
<IPython.core.display.HTML object>
```

] <tune-knn-3>
#block[
```
Fitting 10 folds for each of 5 candidates, totalling 50 fits
KNeighborsRegressor(n_jobs=-1, n_neighbors=3)
```

]
Mean RMSE for tuned ridge (alpha = 0.1) is 1.7915 vs 1.7633 for tuned k-nearest (K = 3), indicating that k-nearest neighbour regression is a better model after tuning. R^2 is the same for both models (R^2 $approx$ 0.97). Both tuned models perform better than with default hyper-parameters, and the difference between tuned models is minor.

Final model selected is the tuned Ridge regression model.

#block[
```python
final_ridge = tuned_ridge
```

] <final-model-2>
== Conclusion
<conclusion>
The two most important features for predicting the heating load are glazing area and relative compactness (#ref(<fig-ridge_2_feature>, supplement: [Figure])), which is reasonable considering larger exposed surface area to the surrounding environment increases heat transfer and glass is a poor insulator compared to walls. Third most important feature is overall height, possibly connected to higher structures being more exposed to the wind stripping away heat.

```python
plot_model(final_ridge, plot="feature")
```

#quarto_super(
kind: 
"quarto-float-fig"
, 
caption: 
[
]
, 
label: 
<fig-ridge_2_feature>
, 
position: 
bottom
, 
supplement: 
"Figure"
, 
subrefnumbering: 
"1a"
, 
subcapnumbering: 
"(a)"
, 
[
#figure([
```
<IPython.core.display.HTML object>
```

], caption: figure.caption(
position: bottom, 
[
Feature importance for the final ridge regression model.
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-ridge_2_feature-1>


#figure([
#box(image("Assignment_3_Rasmus_Hammar_files/figure-typst/fig-ridge_2_feature-output-2.svg"))
], caption: figure.caption(
separator: "", 
position: bottom, 
[
#block[
]
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-ridge_2_feature-2>


]
)




