/* 페이지 정보를 모델링한 데이터 구조 */
function Page(title, url) {
  this.title = title;   // 해당 페이지의 title
  this.url = url;       // 해당 페이지의 url
}

/* 브랜치 정보를 모델링한 데이터 구조 */
function Branch(title) {
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
      console.log(parent.children[index]);
      parent.children[index].removeSubBranch(parent.children[index].traverseDF);

      childToRemove = parent.children.splice(index, 1);
    }
  } else {
    throw new Error ('Parent does not exist.');
  }

  return childToRemove;
};

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

  tree._root.children[0].removeSubBranch(tree._root.children[0].traverseDF);
  console.log(tree._root.children[0]);
