---
{
  slug: 'the-state-of-react-in-2019',
  title: 'The state of React in 2019',
  tags: ['web'],
  publishDate: '2019-03-28',
  description: 'React encourages breaking elements into smaller components.',
}
---

React is a popular library for building interfaces. In a broad stroke it separates creation and rendering of elements in the DOM. This offers notable performance gains.
React encourages breaking elements into smaller components, which can make large applications more robust and scalable.

## How does React pass data to components?

React components contain different ways to pass in and handle the data we need. The two main ways to hand data to a component are to add properties - that is, **props** - or to define its **state**.

## What is a prop?

Components can be passed parameters on creation. These parameters are called props and work in a similar way to arguments passed to a vanilla JavaScript function.

```js
const Cat = ({ image, name }) => {
  return (
    <div className='animal'>
      <img src={image} />
      <span>{name}</span>
    </div>
  );
};

const component = <Cat image='./tabby.jpg' name='Tabby' />;
ReactDOM.render(component, document.getElementById('reactContainer'));
```

## What is a state?

A component’s state is essentially a local-scoped object that can change and be updated. It can only be accessed within the scope of the individual component.

```js

  class WeatherApp extends React.Component {
    constructor(props) {
      super(props);
      this.state = {
        temperature: {
          current: getTemperature()
        }
      };
    }

    getTemperature() {...}

    render() {
        return (
          <div>
            <h1>The current temperature is {this.state.temperature.current}.</h1>
          </div>
        );
      }
    }

```

The data passed to **WeatherApp** comes from its state, which gets updated by **getTemperature()**. For more information on using React with states I recommend the [official documentation](https://reactjs.org/docs/state-and-lifecycle.html).

## What are the differences?

The difference between state and props of a component is that the state of a component can be changed; the properties of a component cannot be changed from inside the component.
Updates to the props of a component must come from being passed new values.

## When should I use state in my application?

There are different ways to organize components. One approach is to split components into presentational and container components.

- **Presentational components** - are concerned with displaying UI and where necessary receiving data for use elsewhere in an App.  
  ‘[presentational components should] receive data as props and send data to their parent component via callback function properties.’

- **Container components** - are components that connect presentational components to the data.

Dan Abramov, co-creator of Redux, cautions against dogmatically following this approach but it may suit certain situations.  
I see it as a useful addition to your react programming toolbox.

I hope this post has proved helpful. The key point I took from writing this post is that, as with most things in life, it pays to **stop** and know **what you are trying to achieve** and **what tools best serve this end** all before starting a project.
