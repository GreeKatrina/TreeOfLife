

  var labelType, useGradients, nativeTextSupport, animate;

  (function() {
    var ua = navigator.userAgent,
        iStuff = ua.match(/iPhone/i) || ua.match(/iPad/i),
        typeOfCanvas = typeof HTMLCanvasElement,
        nativeCanvasSupport = (typeOfCanvas == 'object' || typeOfCanvas == 'function'),
        textSupport = nativeCanvasSupport
          && (typeof document.createElement('canvas').getContext('2d').fillText == 'function');
    //I'm setting this based on the fact that ExCanvas provides text support for IE
    //and that as of today iPhone/iPad current text support is lame
    labelType = (!nativeCanvasSupport || (textSupport && !iStuff))? 'Native' : 'HTML';
    nativeTextSupport = labelType == 'Native';
    useGradients = nativeCanvasSupport;
    animate = !(iStuff || !nativeCanvasSupport);
  })();

  // Where it says what is loading
  var Log = {
    elem: false,
    write: function(text){
      if (!this.elem)
        this.elem = document.getElementById('log');
      this.elem.innerHTML = text;
      this.elem.style.left = (700 - this.elem.offsetWidth / 2) + 'px';
    }
  };


  function init(){
      //init data
      var json = {
          "name": "Tree of Life",
          "id": 1,
          "parent_id": 0,
          "phylesis": 2,
          "extinct": false,
          "leaf": true,
          "data": {},
          "children": []
      };
      //end
      //init Spacetree
      //Create a new ST instance
      var st = new $jit.ST({
          //id of viz container element
          injectInto: 'infovis',
          //set duration for the animation
          duration: 400,
          //set animation transition type
          transition: $jit.Trans.Quart.easeInOut,
          //set distance between node and its children
          levelDistance: 50,
          levelsToShow: 2,
          constrained: false,
          //enable panning
          Navigation: {
            enable:true,
            panning:true
          },
          //set node and edge styles
          //set overridable=true for styling individual
          //nodes or edges
          Node: {
              height: 20,
              width: 150,
              // type: 'nodeline',
              type: 'rectangle',
              color: '#fff',
              // lineWidth: 2,
              // align:"center",
              overridable: true
          },
          setColor: function(node){
              if (node.extinct){
                  node.data.$color =  "#204ABA";
              }else{
                  node.data.$color = '#317fd9';
              }
          },
          // set css for lines
          Edge: {
              type: 'bezier',
              lineWidth: 2,
              color: '#3E3E40',
              overridable: true
          },

          onBeforeCompute: function(node){
              Log.write("loading " + node.name);
          },

          onAfterCompute: function(){
              Log.write("done");
          },
          //Add a request method for requesting on-demand json trees.
          //This method gets called when a node
          //is clicked and its subtree has a smaller depth
          //than the one specified by the levelsToShow parameter.
          //In that case a subtree is requested and is added to the dataset.
          //This method is asynchronous, so you can make an Ajax request for that
          //subtree and then handle it to the onComplete callback.
          //Here we just use a client-side tree generator (the getTree function).
          request: function(nodeId, level, onComplete) {
            $.ajax({
              type: 'GET',
              url: '/node-attributes',
              data: { id: nodeId },
              success: function(newNode) {
                var ans = {
                  'id': nodeId,
                  'children': newNode.children
                };
                onComplete.onComplete(nodeId, ans);
                console.log('oncompleteoncomplete')
              },
              onFailure: function(){
                console.log("failed =(");
              }
            });
          },
          //This method is called on DOM label creation.
          //Use this method to add event handlers and styles to
          //your node.
          onCreateLabel: function(label, node){
              label.id = node.id;
              var style = label.style;
              if (node.name) {
                label.innerHTML = node.name;
                style.width = 147 + 'px';
                style.height = 17 + 'px';
                style.cursor = 'pointer';
                // font color of nodes
                style.color = '#F2F1EF';
                style.fontSize = '0.8em';
                style.textAlign= 'center';
                style.paddingTop = '3px';
              }
              label.onclick = function() {
                  if(!node.anySubnode("exist"))
                     {
                      node['collapsed']=true;
                       node.eachSubgraph(function(subnode) {
                         if(node.id!=subnode.id){
                            subnode.drawn=false;
                            subnode.setData('alpha',1);
                         }
                        });
                        st.onClick(node.id);
                     } else {
                      st.onClick(node.id);
                      node['collapsed']=false;
                        node.eachSubgraph(function(subnode) {
                           if(node.id!=subnode.id) {
                              subnode.exist=false;
                              subnode.drawn=false;
                              subnode.setData('alpha',0);
                           }
                          });
                          st.move(node, {
                            Move: {
                              enable: true,
                              offsetX:  0,
                              offsetY:  0
                            },
                            onComplete: function() {}
                          }); // move
                        }
                  };
          },

          //This method is called right before plotting
          //a node. It's useful for changing an individual node
          //style properties before plotting it.
          //The data properties prefixed with a dollar
          //sign will override the global node style properties.
          onBeforePlotNode: function(node){
              //add some color to the nodes in the path between the
              //root node and the selected node.
              if (node.selected) {
                // set color of nodes along the selected path
                if (node.extinct) {
                    node.data.$color = "#490C60";
                } else {
                    node.data.$color = "#8E44AD";
                }
              } else {
                delete node.data.$color;
                //if the node belongs to the last plotted level
                // console.log("node: ", node);
                // debugger;
                // node.eachSubnode(function(n) {
                //     st.removeSubtree(n.id, true, 'animate', {
                //         hideLabels: false,
                //         onComplete: function() {
                //           removing = false;
                //           console.log('subtree removed')
                //           Log.write("subtree removed");
                //         }
                //     });
                // });

                if(!node.anySubnode("exist")) {
                  if (node.extinct){
                      node.data.$color = "#204ABA";
                  } else {
                      node.data.$color = '#317fd9';
                  }
                }
              }
              // hacky way to make name-less nodes appear as lines
              if (!node.name) {
                  if (node.selected) {
                      node.data.$height = 3;
                      node.data.$color = "#F2F1EF";
                  } else {
                      node.data.$height = 2;
                      node.data.$color  = "#3E3E40";
                  }
              }
          },

          //This method is called right before plotting
          //an edge. It's useful for changing an individual edge
          //style properties before plotting it.
          //Edge data proprties prefixed with a dollar sign will
          //override the Edge global style properties.
          onBeforePlotLine: function(adj){
            if (adj.nodeFrom.selected && adj.nodeTo.selected) {
                // Change color of lines in selected path
                adj.data.$color = "#F2F1EF";
                adj.data.$lineWidth = 3;
            }
            else {
                delete adj.data.$color;
                delete adj.data.$lineWidth;
            }
          }
      });
      //load json data
      st.loadJSON(json);
      //compute node positions and layout
      st.compute();
      //optional: make a translation of the tree
      st.geom.translate(new $jit.Complex(-200, 0), "current");
      //emulate a click on the root node.
      st.onClick(st.root);
      //end

  }

