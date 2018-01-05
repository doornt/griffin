import { IPugBlock } from "../Interface/INode";
export declare class DOMAstManager {
    private $ast;
    private $inputData;
    private $styles;
    constructor(ast: IPugBlock, styles: any);
    compile(data: any): any[];
    private $visitNode(node);
    private $visitBlock(node);
    private $visitText(node);
    private $visitTag(node);
}
