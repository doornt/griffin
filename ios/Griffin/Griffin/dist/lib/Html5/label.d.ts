import { IPugAttr } from "../Interface/INode";
import { RenderComponent } from "../Runtime/export";
export declare class Label extends RenderComponent {
    private $text;
    constructor(attrs: Array<IPugAttr>, styles: any);
    protected parseAttrs(): void;
    protected createView(): void;
}
