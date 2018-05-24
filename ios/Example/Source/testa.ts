
import { BaseComponent } from 'griffin-render';


let pugJson = require(__dirname + '/template/index.pug')

console.log("oug json", JSON.stringify(pugJson))

export class TestAComponent extends BaseComponent {

    private stories = []
    private topStories = []

    private listData = [{
        tag: "A",
        title: "A - 1"
    }, {
        tag: "B",
        title: "B - 1"
    }, {
        tag: "A",
        title: "A - 2"
    }, {
        tag: "B",
        title: "B - 2"
    }]
    constructor() {
        super();
        this.template = pugJson
    }

    jumpToDetail() {
        this.openUrl('/detail', null)
    }

    onAdded() {
        // console.log("TestAComponent onAdded")
        super.onAdded()
        // // this.setState({})        
        // fetch('http://news-at.zhihu.com/api/4/news/latest').then(resp => resp.json()).then(data => {
        //     this.stories = (data.stories || []).map(story => ({
        //         image: story.images[0],
        //         title: story.title,
        //         id: story.id
        //     }))
        //     this.stories = this.stories.concat(this.stories)
        //     // this.stories = this.stories.slice(0, 1)

        //     this.topStories = (data.top_stories || []).map(story => ({
        //         image: story.image,
        //         title: story.title,
        //         id: story.id
        //     }))
        //     this.refresh()

        //     // setTimeout(() => {
        //     // }, 1000);



        // }).catch(err => console.error(err))
    }
}
