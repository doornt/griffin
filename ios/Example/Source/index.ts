
import { BaseComponent } from 'griffin-render'

import { router } from './app'

let pugJson = require(__dirname + '/template/index.pug')

declare var modal: any;

export class TestAComponent extends BaseComponent {

    private stories = []
    private topStories = []

    constructor() {
        super();
        this.template = pugJson
    }

    jumpToDetail() {
        console.log('jump to detail')
        router.push({ name: "testb" })
    }

    onAdded() {
        // console.log("TestAComponent onAdded")
        super.onAdded()
        // // this.setState({})
        fetch('http://api.yatessss.com:8888/news-at/api/4/news/latest').then(resp => resp.json()).then(data => {
            this.stories = (data.stories || []).map(story => ({
                image: story.images[0],
                title: story.title,
                id: story.id
            }))
            this.stories = this.stories.concat(this.stories)
            // this.stories = this.stories.slice(0, 1)

            this.topStories = (data.top_stories || []).map(story => ({
                image: story.image,
                title: story.title,
                id: story.id
            }))
            this.refresh()
        }).catch(err => console.error(err))


        // console.log("setTimeout")

        // setTimeout(() => {
        //     console.log("setTimeout")
        // }, 1000);
    }
}

// launchWithComponent(new TestAComponent())