import { IPugAttr } from "../../Interface/INode";
export declare abstract class RenderComponent {
    protected $attrs: Array<IPugAttr>;
    protected $children: Array<RenderComponent>;
    protected $styles: {};
    protected $instanceId: string;
    constructor(attrs: Array<IPugAttr>, styles: any);
    readonly id: string;
    protected parseAttrs(): void;
    protected abstract createView(): any;
    $render(): void;
    addChild(child: RenderComponent): void;
    protected $buildStyle(k: any, v: any): void;
}
