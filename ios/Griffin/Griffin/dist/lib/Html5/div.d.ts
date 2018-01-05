import { RenderComponent } from "../Runtime/export";
import { IPugAttr } from "../Interface/INode";
export declare class Div extends RenderComponent {
    constructor(attrs: Array<IPugAttr>, styles: any);
    createView(): void;
}
