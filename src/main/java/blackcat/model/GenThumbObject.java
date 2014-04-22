/*
 * Copyright (c) 2014.
 * haojunhua
 */

package blackcat.model;

import blackcat.rules.GenThumbFinishRule;

public class GenThumbObject {
	private Ciyu ciyu;
	private float ratio;
	private GenThumbFinishRule genThumbFinishRule;

	public GenThumbObject(Ciyu ciyu, float ratio, GenThumbFinishRule genThumbFinishRule) {
		this.ciyu = ciyu;
		this.ratio = ratio;
		this.genThumbFinishRule = genThumbFinishRule;
	}

	public Ciyu getCiyu() {
		return ciyu;
	}

	public void setCiyu(Ciyu ciyu) {
		this.ciyu = ciyu;
	}

	public GenThumbFinishRule getGenThumbFinishRule() {
		return genThumbFinishRule;
	}

	public void setImageResizeFinishRule(GenThumbFinishRule genThumbFinishRule) {
		this.genThumbFinishRule = genThumbFinishRule;
	}

	public float getRatio() {
		return ratio;
	}

	public void setRatio(float ratio) {
		this.ratio = ratio;
	}

}
