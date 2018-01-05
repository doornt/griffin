export interface IPugAttr {
    name: string;
    val: string;
}
export interface IPugNode {
    attrs: Array<IPugAttr>;
    type: string;
    name: string;
    block: IPugBlock;
}
export interface IPugText {
    attrs: Array<IPugAttr>;
    type: string;
    val: string;
}
export interface IPugConditional {
    alternate: IPugBlock;
    consequent: IPugBlock;
    test: string;
    type: string;
}
export interface IPugBlock {
    nodes: Array<IPugNode | IPugBlock | IPugConditional | IPugText>;
    type: string;
}
export interface IStyle {
    selector: string;
    attrs: {
        [attr: string]: string;
    };
}
