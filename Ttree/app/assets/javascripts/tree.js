/*! (C) WebReflection Mit Style License */
var CircularJSON=function(e,t){function l(e,t,o){var u=[],f=[e],l=[e],c=[o?n:"[Circular]"],h=e,p=1,d;return function(e,v){return t&&(v=t.call(this,e,v)),e!==""&&(h!==this&&(d=p-a.call(f,this)-1,p-=d,f.splice(p,f.length),u.splice(p-1,u.length),h=this),typeof v=="object"&&v?(a.call(f,v)<0&&f.push(h=v),p=f.length,d=a.call(l,v),d<0?(d=l.push(v)-1,o?(u.push((""+e).replace(s,r)),c[d]=n+u.join(n)):c[d]=c[0]):v=c[d]):typeof v=="string"&&o&&(v=v.replace(r,i).replace(n,r))),v}}function c(e,t){for(var r=0,i=t.length;r<i;e=e[t[r++].replace(o,n)]);return e}function h(e){return function(t,s){var o=typeof s=="string";return o&&s.charAt(0)===n?new f(s.slice(1)):(t===""&&(s=v(s,s,{})),o&&(s=s.replace(u,"$1"+n).replace(i,r)),e?e.call(this,t,s):s)}}function p(e,t,n){for(var r=0,i=t.length;r<i;r++)t[r]=v(e,t[r],n);return t}function d(e,t,n){for(var r in t)t.hasOwnProperty(r)&&(t[r]=v(e,t[r],n));return t}function v(e,t,r){return t instanceof Array?p(e,t,r):t instanceof f?t.length?r.hasOwnProperty(t)?r[t]:r[t]=c(e,t.split(n)):e:t instanceof Object?d(e,t,r):t}function m(t,n,r,i){return e.stringify(t,l(t,n,!i),r)}function g(t,n){return e.parse(t,h(n))}var n="~",r="\\x"+("0"+n.charCodeAt(0).toString(16)).slice(-2),i="\\"+r,s=new t(r,"g"),o=new t(i,"g"),u=new t("(?:^|([^\\\\]))"+i),a=[].indexOf||function(e){for(var t=this.length;t--&&this[t]!==e;);return t},f=String;return{stringify:m,parse:g}}(JSON,RegExp);

/* 페이지 정보를 모델링한 데이터 구조 */
function Page(title, url) {
  this.title = title;   // 해당 페이지의 title
  this.url = url;       // 해당 페이지의 url
}

/* 브랜치 정보를 모델링한 데이터 구조 */
function Branch(title) {
  this.id = null;
  this.pages = [];
  this.title = title;
  this.parent = null;
  this.children = [];
}

/* 작업 단위 하나를 의미하는 데이터 구조 */
function Tree(title) {
  var branch = new Branch(title);
  this._root = branch;
}

/* BF를 구현하기 위한 queue 헬퍼 */
function Queue() {
  this.data = [];
}

/* 해당 브랜치를 DF로 순회 */
Branch.prototype.traverseDF = function(callback) {
  (function recurse(currentNode) {
    for (var i = 0, length = currentNode.children.length; i < length; i++) {
      recurse(currentNode.children[i]);
    }
    console.log(currentNode.title);
    callback(currentNode);
  })(this);
};

/* 해당 노드 이하의 모든 자식들을 삭제함 */
Branch.prototype.removeSubBranch = function(traversal) {
  var callback = function(branch) {
    branch.parent = null;
    branch.children = [];
  };

  traversal.call(this, callback);
};

/* queue에 data를 삽입함 */
Queue.prototype.enqueue = function(data) {
  this.data.push(data);
};

/* queue에서 요소 하나를 pop 해옴 */
Queue.prototype.dequeue = function() {
  return this.data.shift();
};

/*
  DF로 구현한 트리 순회
  callback을 등록하여 트리의 노드에 작업을 걸을 수 있음
*/
Tree.prototype.traverseDF = function(callback) {
  (function recurse(currentNode) {
    for (var i = 0, length = currentNode.children.length; i < length; i++) {
      recurse(currentNode.children[i]);
    }

    callback(currentNode);
  })(this._root);
};

/*
  BF로 구현한 트리 순회
  callback을 등록하여 트리의 노드에 작업을 걸을 수 있음
*/
Tree.prototype.traverseBF = function(callback) {
  var queue = new Queue();

  queue.enqueue(this._root);

  currentTree = queue.dequeue();

  while (currentTree) {
    for (var i = 0, length = currentTree.children.length; i < length; i++) {
      queue.enqueue(currentTree.children[i]);
    }

    callback(currentTree);
    currentTree = queue.dequeue();
  }
};

/* callback을 등록하여 트리를 순회하면서 작업을 걸을 수 있음 */
Tree.prototype.contains = function(callback, traversal) {
  traversal.call(this, callback);
};

/*
  tree에 add 작업을 수행하는 메소드
  Usage: add(title, parentTitle, traversal)
  title: 새로 등록할 branch의 title
  parentTitle: 새로 등록할 branch의 부모 branch
  traversal: 트리 순회 방식 지정
*/
Tree.prototype.add = function(title, parentTitle, traversal) {
  var child = new Branch(title)
  var parent = null;
  var callback = function(branch) {
    if (branch.title === parentTitle) {
      parent = branch;
    }
  };

  this.contains(callback, traversal);

  if (parent) {
    parent.children.push(child);
    child.parent = parent;
  } else {
    throw new Error('Cannot add node to non existent parent.');
  }
};

/*
  tree에 remove 작업을 수행하는 메소드
  Usage: remove(title, parentTitle, traversal)
  title: 삭제할 branch의 title
  parentTitle: 삭제할 branch의 부모 branch
  traversal: 트리 순회 방식 지정
*/
Tree.prototype.remove = function(title, parentTitle, traversal) {
  var tree = this,
      parent = null,
      childToRemove = null,
      index;

  var callback = function(branch) {
    if (branch.title === parentTitle) {
      parent = branch;
    }
  };

  /* 배열에서 찾고자하는 data의 index를 리턴함 */
  var findIndex = function(arr, data) {
    var index;

    for (var i = 0; i < arr.length; i++) {
      if (arr[i].title === data) {
        index = i;
      }
    }

    return index;
  };

  this.contains(callback, traversal);

  if (parent) {
    index = findIndex(parent.children, title);

    if (index === undefined) {
      throw new Error('Node to remove does not exist.');
    } else {
      parent.children[index].removeSubBranch(parent.children[index].traverseDF);

      childToRemove = parent.children.splice(index, 1);
    }
  } else {
    throw new Error ('Parent does not exist.');
  }

  return childToRemove;
};

Tree.prototype.first = function(search_title, traversal) {
  var first = null;

  var callback = function(branch) {
    if (branch.title === search_title) {
      first = branch;
    }
  }
}

/* test code */
var tree = new Tree('one');

tree.add('two', 'one', tree.traverseBF);
tree.add('three', 'one', tree.traverseBF);
tree.add('four', 'one', tree.traverseBF);

tree.add('five', 'two', tree.traverseBF);
tree.add('six', 'two', tree.traverseBF);

tree.add('seven', 'four', tree.traverseBF);

tree.traverseDF(function(branch) {
  console.log(branch.title)
})

console.log("-----------------------------------------");

tree.traverseBF(function(branch) {
  console.log(branch.title);
})

console.log("-----------------------------------------");

tree.contains(function(branch){
  if (branch.title === 'two') {
    console.log(branch);
  }
}, tree.traverseBF);

console.log("-----------------------------------------");

tree.remove('two', 'one', tree.traverseBF);

tree.traverseBF(function(branch) {
  console.log(branch.title);
});

console.log("-----------------------------------------");
console.log("Memory Leak Test");

tree = new Tree(1);
for (var i = 1; i < 100; i++) {
  tree.add(i + 1, i, tree.traverseDF);
}

//tree._root.children[0].removeSubBranch(tree._root.children[0].traverseDF);
console.log(tree._root.children[0]);

var CircularJSON = window.CircularJSON;

dat = CircularJSON.stringify(tree);
test = CircularJSON.parse(dat);
test2 = new Tree(test);
