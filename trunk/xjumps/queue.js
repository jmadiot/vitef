function Queue(){

  var queue = [];

  var queueSpace = 0;

  this.getSize = function(){
     return queue.length - queueSpace;
  }

  this.isEmpty = function(){
    return (queue.length == 0);
  }

  this.enqueue = function(element){
    queue.push(element);
  }

  this.dequeue = function(){
    var element = undefined;
    if (queue.length){
      element = queue[queueSpace];
      if (++queueSpace * 2 >= queue.length){
        queue = queue.slice(queueSpace);
        queueSpace=0;
      }
      

    }
    return element;
  }
  this.getOldestElement = function(){
    var element = undefined;
    if (queue.length) element = queue[queueSpace];
    return element;
  }
}
